//
//  ContentView.swift
//  Friday
//
//  Created by Nethan on 4/2/23.
//

import SwiftUI
import OpenAISwift
import SwiftUIGIF
import Speech
import AVFoundation
                              
                              



final class ViewModel: ObservableObject {
    init() {}
    private var client: OpenAISwift?
    func setup() {
        client = OpenAISwift(authToken: "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")
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text,
                               maxTokens: 500,
                               completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                   completion(output)
            case .failure:
                break
            }
        })
        
    }
}
struct ContentView: View {
    @StateObject var voiceRecogniser = VoiceRecogniser()
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var imageLink = ""
   @State var talking = true
    @State var stoppedTalking = false
    @State var talks = "nobody"
    let synthesizer = AVSpeechSynthesizer()
    @State var spokenText = ""
    @State var robotResponse = ""
    var body: some View {
        
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image("\(imageLink)")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("\(voiceRecogniser.transcript)")
                Spacer()
                
                if talks == "nobody" {
                    Button {
                        talks = "human"
                        
                        
                                       
                                       voiceRecogniser.reset()
                                       voiceRecogniser.transcribe()
                       
                    } label: {
                        Image(systemName: "mic.circle.fill")
                            .font(.system(size: 75))
                            .foregroundColor(.white)
                    }
                } else if talks == "human" {
                    Button("Stop") {
                   
                        talking = true
                        
                        if voiceRecogniser.transcript == "" {
                            talks = "nobody"
                            voiceRecogniser.stopTranscribing()
                        } else {
                         
                            spokenText = voiceRecogniser.transcript
                            voiceRecogniser.stopTranscribing()
                            send()
                            talks = "robot"
                        }
                        if talks == "robot" {
                         
                                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
                                    
                                    let seconds = 0.3
                                    let seconds2 = 0.6
                                    let seconds3 = 0.9
                                    let seconds4 = 1.2
                                    let seconds5 = 1.5
                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                        imageLink = "happy talking 1"
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
                                        imageLink = "happy talking 1"
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds3) {
                                        imageLink = "Happy"
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds4) {
                                        imageLink = "Happy talking"
                                        
                                    }
                                    
                                   
                                    
                                
                                
                            }
                            
                            let utterance = AVSpeechUtterance(string: "\(robotResponse)")
                                                utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
                                                utterance.rate = 0.5
                                                
                                                
                                                synthesizer.speak(utterance)
                                        
                                                spokenText = ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                           talks = "nobody"
                                
                            }
                            
                                                
                            
                        }
                    }
                }
                Spacer()
            }
            
           
            
        }
        .onAppear {
            imageLink = "Surprised"
            viewModel.setup()
            
        
                
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: talking) { timer in
                    
                    let seconds = 0.2
                let seconds2 = 0.4
                let seconds3 = 0.6
                let seconds4 = 0.8
                let seconds5 = 2.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        imageLink = "blink1"
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
                        imageLink = "blink2"
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds3) {
                        imageLink = "blink3"
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds4) {
                        imageLink = "Surprised"
                        
                    }
                
            }
        }
    }
    
    func send() {
        
        print(spokenText)
        
        viewModel.send(text: spokenText) { response in
            DispatchQueue.main.async {
                robotResponse = response
                print("ChatGPT: \(robotResponse)")
            }
        }
    }
    
    func blink() {
 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
