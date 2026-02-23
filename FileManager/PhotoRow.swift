//
//  PhotoRow.swift
//  FileManager
//
//  Created by Кирилл Паничкин on 2/23/26.
//

import SwiftUI

struct PhotoRow: View {
    let filename: String
    let fullPath: String

    private var fileSize: String {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: fullPath),
              let size = attrs[.size] as? Int else { return "" }
        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }

    var body: some View {
        HStack(spacing: 14) {
            if let uiImage = UIImage(contentsOfFile: fullPath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(filename)
                    .font(.system(size: 15, weight: .medium))
                    .lineLimit(1)
                Text(fileSize)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
