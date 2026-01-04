from PIL import Image
import os

def to_rgba5551(img: Image.Image) -> bytes:
    img = img.convert("RGBA")
    w, h = img.size
    px = img.load()
    out = bytearray(w * h * 2)

    i = 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            r5 = (r * 31) // 255
            g5 = (g * 31) // 255
            b5 = (b * 31) // 255
            a1 = 1 if a >= 128 else 0
            val = (a1 << 15) | (b5 << 10) | (g5 << 5) | r5
            out[i] = val & 0xFF
            out[i+1] = (val >> 8) & 0xFF
            i += 2

    return bytes(out)

def convert(in_path: str, out_path: str):
    img = Image.open(in_path)
    raw = to_rgba5551(img)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "wb") as f:
        f.write(raw)
    print(f"OK {in_path} -> {out_path} ({img.size[0]}x{img.size[1]})")

def main():
    # Genera SIEMPRE los mismos nombres
    convert("assets_src/bg.png", "assets_build/bg.raw")
    convert("assets_src/disc_icon.png", "assets_build/disc.raw")

if __name__ == "__main__":
    main()
