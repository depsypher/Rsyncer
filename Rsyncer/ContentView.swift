//
//  ContentView.swift
//  Rsyncer
//
//  Created by Ray Vanderborght on 2023-10-16.
//

import SwiftUI
import AVFoundation

var audioPlayer: AVAudioPlayer!

struct ContentView: View {
    let dropSound = Bundle.main.url(forResource: "Volume Mount", withExtension: "aif")

    @AppStorage("path") var path = "/"
    @State var dirs: [URL]?

    var body: some View {
        VStack {
            HStack {
                Text("Copy to: " + path.removingPercentEncoding!)
                Spacer()
                Image(systemName: "arrow.uturn.up.square").imageScale(.large).foregroundStyle(.tint)
                    .disabled(path == "/")
                    .onTapGesture(count: 2) {
                        moveUp()
                    }
                    .onTapGesture(count: 1) {
                        moveUp()
                    }
            }
            if dirs != nil {
                List {
                    ForEach(dirs!.sorted(by: { a, b in
                        a.absoluteString.lowercased() < b.absoluteString.lowercased()
                    }), id:\.self) { dir in
                        Text(dir.path().removingPercentEncoding!)
                            .onTapGesture(count: 2) {
                                path = dir.path().removingPercentEncoding!
                                updateDirContents()
                            }
                            .onTapGesture(count: 1) {
                                path = dir.path().removingPercentEncoding!
                                updateDirContents()
                            }
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .dropDestination(for: URL.self) { items, location in
            drop(items: items)
            return true
        }
        .onOpenURL(perform: { url in
            drop(items: [url])
         })
        .onAppear() {
            updateDirContents()
        }
    }
    
    func drop(items: [URL]) {
        items.forEach {
            let task = Process()
            task.launchPath = "/usr/bin/rsync"
            task.arguments = [$0.path().removingPercentEncoding!, path.removingPercentEncoding!]
            
            do {
                try task.run()
            } catch let error {
                print(error)
            }
        }
        
        audioPlayer = try! AVAudioPlayer(contentsOf: dropSound!)
        audioPlayer.play()
    }

    func moveUp() {
        if path != "/" {
            path = String(path[path.startIndex..<path.lastIndex(of: "/")!])
            path = String(path[path.startIndex..<path.lastIndex(of: "/")!] + "/")
            updateDirContents()
        }
    }

    func updateDirContents() {
        let fm = FileManager.default

        dirs = []
        do {
            let files = try fm.contentsOfDirectory(at: URL(string: path)!, includingPropertiesForKeys: nil)

            for item in files {
                let attribs = try fm.attributesOfItem(atPath: item.path().removingPercentEncoding!)
                let type = attribs[FileAttributeKey.type]
                if type as! String == "NSFileTypeDirectory" {
                    dirs?.append(item)
                }
            }
        } catch let error {
            print(error)
            if path != "/" {
                path = "/"
                updateDirContents()
            }
        }
    }
}
