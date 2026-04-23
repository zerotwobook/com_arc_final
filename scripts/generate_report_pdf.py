from pathlib import Path

from reportlab.lib.pagesizes import A4
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.pdfgen import canvas


ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = ROOT / "report" / "report.md"
OUTPUT_PATH = ROOT / "report" / "report.pdf"

PAGE_WIDTH, PAGE_HEIGHT = A4
LEFT_MARGIN = 54
TOP_MARGIN = 54
BOTTOM_MARGIN = 54
LINE_HEIGHT = 14
FONT_NAME = "Courier"
FONT_SIZE = 10
MAX_WIDTH = PAGE_WIDTH - (2 * LEFT_MARGIN)


def normalize_line(line: str) -> str:
    stripped = line.rstrip("\n")
    if stripped.startswith("# "):
        return stripped[2:]
    if stripped.startswith("## "):
        return stripped[3:]
    if stripped.startswith("### "):
        return stripped[4:]
    if stripped.startswith("#### "):
        return stripped[5:]
    if stripped.startswith("- "):
        return "* " + stripped[2:]
    return stripped


def wrap_line(text: str) -> list[str]:
    if not text:
        return [""]

    words = text.split(" ")
    lines = []
    current = words[0]

    for word in words[1:]:
        trial = current + " " + word
        if stringWidth(trial, FONT_NAME, FONT_SIZE) <= MAX_WIDTH:
            current = trial
        else:
            lines.append(current)
            current = word

    lines.append(current)
    return lines


def draw_report() -> None:
    raw_lines = INPUT_PATH.read_text(encoding="utf-8").splitlines()
    normalized_lines = []
    for raw_line in raw_lines:
        normalized_lines.extend(wrap_line(normalize_line(raw_line)))

    pdf = canvas.Canvas(str(OUTPUT_PATH), pagesize=A4)
    pdf.setTitle("SAP-1 Mini Project Report")
    pdf.setFont(FONT_NAME, FONT_SIZE)

    y = PAGE_HEIGHT - TOP_MARGIN
    for line in normalized_lines:
        if y <= BOTTOM_MARGIN:
            pdf.showPage()
            pdf.setFont(FONT_NAME, FONT_SIZE)
            y = PAGE_HEIGHT - TOP_MARGIN
        pdf.drawString(LEFT_MARGIN, y, line)
        y -= LINE_HEIGHT

    pdf.save()


if __name__ == "__main__":
    draw_report()
