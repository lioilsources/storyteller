// Flags renders flux-schnell lettered with fake text: macOS Vision OCR,
// one "<path>\t<recognized chars>" line per path read from stdin.
// >= 12 chars is lettering; a corner signature reads shorter.
//   ls rag/data/motif_images/*.jpg | swift tools/find-lettering.swift
import Vision
import AppKit
while let line = readLine() {
    guard let img = NSImage(contentsOfFile: line), let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else { continue }
    let req = VNRecognizeTextRequest()
    req.recognitionLevel = .fast
    try? VNImageRequestHandler(cgImage: cg).perform([req])
    let n = (req.results ?? []).compactMap { $0.topCandidates(1).first?.string }.joined().count
    print("\(line)\t\(n)")
}
