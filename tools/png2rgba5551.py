from PIL import Image
import sys
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

def main():
    if len(sys.argv) != 3:
        print("Uso: python png2rgba5551.py input.png output.raw")
        sys.exit(1)

    in_path, out_path = sys.argv[1], sys.argv[2]
    img = Image.open(in_path)
    w, h = img.size

    raw = to_rgba5551(img)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)

    with open(out_path, "wb") as f:
        f.write(raw)

    print(f"OK: {in_path} -> {out_path} ({w}x{h}, {len(raw)} bytes)")

if __name__ == "__main__":
    main()
