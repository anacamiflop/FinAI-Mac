//
//  HomeViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 21/10/26.
//

import UIKit

class HomeViewController: UITabBarController {
    /*
    @IBOutlet weak var lblName: UILabel!
    
    private let name: String
    
    init?(coder: NSCoder, name: String) {
        self.name = name
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // Este error mata la app y manda alerta al usuario
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        lblName.text = name
     
        }
     */
    
    // TODO: - Separarlo por funciones
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        // Apariencia
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground // Solo para el iOS < 26
        
        // < iOS 26: TabBar cambió, NO PERMITE más de 4 elementos y una acción
        // <: Permite más personalización y más elementos
        
        // Aplica la apariencia en estados [normal, scroll]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        // Colores de los elementos
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .secondaryLabel
        
        let listVC = UIStoryboard(
            name : "List",
            bundle: nil
        ).instantiateViewController(
            identifier: "ListViewController"
        ) {coder in
            return ListViewController(coder: coder)
        }
        
        let listItem = createNavigationController(for: listVC, title: "List", image: UIImage(systemName: "list.bullet")) // person.fill
        
        let profileVC = UIStoryboard(
            name : "Profile",
            bundle: nil
        ).instantiateViewController(
            identifier: "ProfileViewController"
        ) {coder in
            return ProfileViewController(coder: coder)
        }
        
        let profileItem = createNavigationController(for: profileVC, title: "Profile", image: UIImage(systemName: "person.fill"))
        
        setViewControllers([listItem, profileItem], animated: true)
        
    }
    
    private func createNavigationController(for rootVC: UIViewController, title: String?, image: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootVC) // Crear un UINavigationController
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = image?.withRenderingMode(.alwaysTemplate) // Me permite cambiar la imagen del tab
        
        // Opcional: Cofigurar el título del navigation bar
        rootVC.navigationItem.title = title
        return navController
    }
}
