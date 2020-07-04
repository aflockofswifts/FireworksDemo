//
//  ContentView.swift
//  Demo
//
//  Created by Ray Fix on 7/4/20.
//

import SpriteKit
import SwiftUI
import Combine

final class Fireworks: SKScene { }

final class FireworksViewModel: ObservableObject {
  private var fireworks: Fireworks
  private var timer: AnyCancellable?
  
  func fireworks(size: CGSize) -> Fireworks {
    fireworks.size = size
    return fireworks
  }
  
  func explode() {
    let firework = SKEmitterNode(fileNamed: "Firework.sks")!
    firework.position =
      CGPoint(x: CGFloat.random(in: 0...fireworks.size.width),
              y: CGFloat.random(in: 0...fireworks.size.height))
    
    fireworks.addChild(firework)
    firework.run(SKAction.sequence([.wait(forDuration: 1), .removeFromParent()]))
  }
  
  func startShow() {
    timer = Timer.publish(every: 0.1, on: .main, in: .common)
      .autoconnect()
      .sink { _ in
        self.explode()
      }
  }
  
  init() {
    fireworks = Fireworks()
  }

}

struct ContentView: View {
  
  @StateObject var viewModel = FireworksViewModel()

  var body: some View {
    ZStack {
      GeometryReader { proxy in
        SpriteView(scene: viewModel.fireworks(size: proxy.size))
          .frame(width: proxy.size.width, height: proxy.size.height)
      }
      Text("Happy 4th!").font(.largeTitle)
        .foregroundColor(.white).bold()
    }
    .edgesIgnoringSafeArea(.all)
    .onAppear {
      viewModel.startShow()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
