//
//  ProfileViewController 2.swift
//  HelloWorld
//
//  Created by Ana Camila Lopez Rojano on 04/11/26.
//


//
//  ProfileViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 26/10/26.
//

import UIKit
import AVKit
import AVFoundation

class ProfileViewController: UIViewController {
    
    var player: AVPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - CREAR MIS UI BAR BUTTON ITEM
        // Crear componentes de manera programada
        // Componentes exclusivos
        
        let helpButton = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(didTapHelp))
        navigationItem.setLeftBarButtonItems([helpButton], animated: true)
        
        let startButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didTapStart))
        startButton.tintColor = .green// personalizar el icono
        
        let stopButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didTapStop))
        stopButton.tintColor = .red// personalizar el icono
        
        
        navigationItem.setRightBarButtonItems([helpButton], animated: false)
        navigationItem.setRightBarButtonItems([stopButton,startButton], animated: false)

        
    }
    
    @objc private func didTapHelp() {
        let videoUrl = " https://cdn.lephenix.fr/wp-content/uploads/2022/10/07104840/big_buck_bunny_720p_1mb.mp4 " // URL DE UN VIDEO X
        
        //Asegurarnos de que este videoUrl sea un url
        guard let url = URL(string: videoUrl) else{
            print("Invalid URL")
            return
            
        }
        
        //Iniciar nuestro Url
        let player = AVPlayer(url: url)
        
        //Crear un viewcontroller al que le mandemos el player
        
        let playerViewController = AVPlayerViewController()
        
        //Aseguramos nuestro reproductor creado al del viewController
        playerViewController.player = player
        
        guard let nav = navigationController else{
            return
        }
        
        //nav.push = navegas de un viewcontroler a otro, stack de navegación
        //nav.present = no navegas pero muestras un viewcontroller en otro
        //(lo sobrepone pero tmb vive dentro del stack de navegación)
        
        nav.present(playerViewController, animated: true){
            player.play()
        }
        
    }
    
    @objc private func didTapStart() {
        let audioUrlString = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 " //Audio que termine en mp3
        
        //Asegurarse de que sea .mp3
        guard let url = URL(string: audioUrlString)else{
            print("Invalid url audio")
            return
        }
        
        do{
            //Intentar crear una instancia de reproductor de audio
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //Iniciar nuestro player global
            self.player = AVPlayer(url: url)
            
            //Validar que no sea un nil
            guard let play = self.player else{
                print("player es nil")
                return
            }
            // ya le dimos play a la cancion
            play.play( )
        }
        catch { //error
            print(error.localizedDescription)}
    }
    
    @objc private func didTapStop() {
        guard let player = self.player else{
            print("Player is nil")
            return
        }
        //Si no es nil entonces puedo darle pause
        player.pause()
        
        //para parar todo
        self.player = nil
    
}
}

