"""
Simple PDF → Markdown converter using PyMuPDF (fitz).

Usage:
    /Users/emmanuel/Dev/Foundation/.venv/bin/python tools/pdf_to_markdown.py \
        /Users/emmanuel/Dev/Foundation/.planning/AlgorithmforDecisionMaking.pdf \
        /Users/emmanuel/Dev/Foundation/.planning/AlgorithmforDecisionMaking-md

What it does:
- Extracts text spans and uses font size heuristics to detect headings.
- Splits content into sections when a heading is found; otherwise falls back to per-page files.
- Extracts images into an `assets/` folder and saves them alongside markdown files.
- Writes YAML frontmatter (title, source, date) at the top of each markdown file.

Notes / limitations:
- Heuristics: headings are spans with font-size >= median_size * 1.20.
- Complex PDFs with inconsistent fonts/layout may not split perfectly. This is a pragmatic conversion.
"""
import fitz
import os
import sys
import re
from slugify import slugify
import frontmatter
from datetime import date


def ensure_dir(p):
    if not os.path.exists(p):
        os.makedirs(p, exist_ok=True)


def save_image(doc, xref, out_dir, page_num):
    try:
        pix = fitz.Pixmap(doc, xref)
        ext = "png" if pix.alpha else "png"
        fname = f"image_p{page_num+1}_x{xref}.{ext}"
        out_path = os.path.join(out_dir, fname)
        # convert CMYK or others to RGB
        if pix.n - pix.alpha < 4:
            pix.save(out_path)
        else:
            pix1 = fitz.Pixmap(fitz.csRGB, pix)
            pix1.save(out_path)
            pix1 = None
        pix = None
        return fname
    except Exception as e:
        return None


def extract(pdf_path, out_dir):
    doc = fitz.open(pdf_path)
    ensure_dir(out_dir)
    assets_dir = os.path.join(out_dir, "assets")
    ensure_dir(assets_dir)

    # First pass: collect span sizes
    sizes = []
    spans = []  # (page, y0, size, text)
    for pno in range(len(doc)):
        page = doc[pno]
        blocks = page.get_text("dict").get("blocks", [])
        for b in blocks:
            if "lines" not in b:
                continue
            for line in b["lines"]:
                for span in line["spans"]:
                    text = span.get("text", "").strip()
                    if not text:
                        continue
                    size = span.get("size", 0)
                    y0 = span.get("origin", [0, 0])[1]
                    sizes.append(size)
                    spans.append((pno, y0, size, text))

    median_size = 0
    if sizes:
        sizes_sorted = sorted(sizes)
        mid = len(sizes_sorted) // 2
        median_size = sizes_sorted[mid]
    heading_threshold = median_size * 1.20 if median_size > 0 else 12

    # Build sections
    sections = []
    cur = {"title": None, "content": []}

    # sort spans by page then y position
    spans.sort(key=lambda s: (s[0], s[1]))

    for (pno, y0, size, text) in spans:
        # heuristics to ignore stray short artifacts
        if len(text) <= 1:
            continue
        is_heading = size >= heading_threshold and len(text) < 200
        # additional heuristic: lines in ALL CAPS or starting with 'Chapter' are headings
        if not is_heading:
            if re.match(r"^(CHAPTER|Chapter|CHAPTER\s+\d+|Chapter\s+\d+)", text):
                is_heading = True
            elif text.upper() == text and len(text) > 3 and not text.endswith('.'):
                is_heading = True

        if is_heading:
            # start new section
            if cur["title"] or cur["content"]:
                sections.append(cur)
            cur = {"title": text.strip(), "content": [f"_Source page: {pno+1}_\n"]}
        else:
            cur["content"].append(text)

    # append last
    if cur["title"] or cur["content"]:
        sections.append(cur)

    # If we found no headings, fallback to per-page files
    if not any(s.get("title") for s in sections):
        sections = []
        for pno in range(len(doc)):
            text = doc[pno].get_text("text").strip()
            sections.append({"title": f"Page {pno+1}", "content": [text]})

    # Extract images and save (map xref -> filename)
    xref_map = {}
    for pno in range(len(doc)):
        page = doc[pno]
        imgs = page.get_images(full=True)
        for img in imgs:
            xref = img[0]
            if xref in xref_map:
                continue
            saved = save_image(doc, xref, assets_dir, pno)
            if saved:
                xref_map[xref] = os.path.join("assets", saved)

    # Write sections to files
    written = []
    for idx, sec in enumerate(sections, start=1):
        title = sec.get("title") or f"section-{idx}"
        slug = slugify(title)[:200] or f"section-{idx}"
        mdname = f"{idx:02d}-{slug}.md"
        mdpath = os.path.join(out_dir, mdname)

        # assemble body
        body_lines = []
        if title:
            body_lines.append(f"# {title}\n")
        for c in sec.get("content", []):
            # naive image placeholder replacement: look for '/Im' references (rare) - skipped
            body_lines.append(c + "\n\n")

        fm = {
            "title": title,
            "source": os.path.basename(pdf_path),
            "converted": date.today().isoformat(),
        }
        post = frontmatter.Post('\n'.join(body_lines), **fm)
        with open(mdpath, "w", encoding="utf-8") as f:
            f.write(frontmatter.dumps(post))
        written.append(mdpath)

    # Basic TOC file
    toc_path = os.path.join(out_dir, "_TOC.md")
    with open(toc_path, "w", encoding="utf-8") as t:
        t.write(f"# Table of Contents\n\nSource: {os.path.basename(pdf_path)}\n\n")
        for p in written:
            name = os.path.basename(p)
            # extract title from frontmatter
            with open(p, "r", encoding="utf-8") as pp:
                content = pp.read()
            m = re.search(r"^title: (.*)$", content, re.MULTILINE)
            title = m.group(1) if m else name
            t.write(f"- [{title}]({name})\n")

    return out_dir


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: pdf_to_markdown.py <input.pdf> [output_dir]")
        sys.exit(1)
    pdf = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else pdf.rstrip('.pdf') + '-md'
    out = os.path.abspath(out)
    res = extract(pdf, out)
    print("Wrote markdown to:", res)
