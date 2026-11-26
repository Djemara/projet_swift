import Foundation

// ---------- Données du programme ----------
let biblio = Bibliotheque()
var adherents: [Adherent] = []

// ---------- Utilitaires ----------
func lireTexte(_ message: String) -> String {
    print(message, terminator: " ")
    return (readLine() ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
}

// Renvoie nil si la saisie n'est pas un nombre entier
func lireEntier(_ message: String) -> Int? {
    return Int(lireTexte(message))
}

func choisirAdherent() -> Adherent? {
    guard !adherents.isEmpty else {
        print("Aucun adhérent. Créez-en un d'abord (Gestion des adhérents).")
        return nil
    }
    let nom = lireTexte("Nom de l'adhérent :").lowercased()
    guard let a = adherents.first(where: { $0.nom.lowercased() == nom }) else {
        print("Adhérent introuvable.")
        return nil
    }
    return a
}

func libelleType(_ livre: Livre) -> String {
    return livre is LivreNumerique ? "Numérique" : "Papier"
}

func choisirLivre() -> Livre? {
    guard !biblio.livres.isEmpty else {
        print("Le catalogue est vide. Ajoutez d'abord des livres (Gestion de la bibliothèque).")
        return nil
    }
    let titre = lireTexte("Titre du livre :")
    let trouves = biblio.rechercherLivres(titre: titre)

    if trouves.isEmpty {
        print("Livre introuvable dans le catalogue.")
        return nil
    }
    if trouves.count == 1 {
        return trouves[0]
    }

    // Plusieurs livres portent ce titre : l'utilisateur choisit
    print("Plusieurs versions de ce livre existent :")
    for (i, livre) in trouves.enumerated() {
        let etat = livre.estDisponible ? "disponible" : "emprunté"
        // ← LIGNE MODIFIÉE : affiche maintenant l'auteur aussi
        print("\(i + 1). \(livre.titre), de \(livre.auteur) (\(libelleType(livre)), \(etat))")
    }
    while true {
        if let n = lireEntier("Votre choix :"), n >= 1, n <= trouves.count {
            return trouves[n - 1]
        }
        print("Choix invalide, entrez un nombre entre 1 et \(trouves.count).")
    }
}

// ---------- 1. Gestion de la bibliothèque ----------
// ---------- Saisies avec répétition jusqu'à une valeur valide ----------
func lireTypeLivre() -> String {
    while true {
        let type = lireTexte("Type de livre (1 = papier, 2 = numérique) :")
        if type == "1" || type == "2" { return type }
        print("Choix invalide : entrez 1 ou 2.")
    }
}

func lireTitre() -> String {
    while true {
        let titre = lireTexte("Titre :")
        if Livre.titreValide(titre) { return titre }
        print("Erreur : le titre ne peut pas être vide.")
    }
}

// Vrai si un livre de même titre, même auteur et même type existe déjà
func livreExisteDeja(titre: String, auteur: String, type: String) -> Bool {
    let auteurRecherche = auteur.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    return biblio.rechercherLivres(titre: titre).contains {
        $0.auteur.lowercased() == auteurRecherche
            && (type == "1" ? ($0 is LivrePapier) : ($0 is LivreNumerique))
    }
}
func lireAuteur() -> String {
    while true {
        let auteur = lireTexte("Auteur :")
        if Livre.auteurValide(auteur) { return auteur }
        print("Erreur : l'auteur ne peut pas être vide et ne doit contenir que des lettres.")
    }
}

func lireEntierPositif(_ message: String) -> Int {
    while true {
        if let n = lireEntier(message), n > 0 { return n }
        print("Erreur : entrez un nombre entier supérieur à 0.")
    }
}

// ---------- Ajouter un livre ----------
func ajouterUnLivre() {
    let type = lireTypeLivre()

    var titre = ""
    var auteur = ""
    while true {
        titre = lireTitre()
        auteur = lireAuteur()
        if livreExisteDeja(titre: titre, auteur: auteur, type: type) {
            print("Erreur : ce livre existe déjà (même titre, même auteur, même type). Recommencez.")
        } else {
            break
        }
    }

    if type == "1" {
        let pages = lireEntierPositif("Nombre de pages :")
        if let livre = LivrePapier(titre: titre, auteur: auteur, nombrePages: pages) {
            biblio.ajouterLivre(livre)
        }
    } else {
        let taille = lireEntierPositif("Taille du fichier (Mo) :")
        if let livre = LivreNumerique(titre: titre, auteur: auteur, tailleFichierMo: taille) {
            biblio.ajouterLivre(livre)
        }
    }
}

func menuBibliotheque() {
    var retour = false
    while !retour {
        print("""

        --- Gestion de la bibliothèque ---
        1. Ajouter un livre
        2. Afficher le catalogue
        3. Rechercher un livre
        0. Retour au menu principal
        """)
        switch lireTexte("Votre choix :") {
        case "1":
            ajouterUnLivre()
        case "2":
            biblio.afficherCatalogue()
        case "3":
            let titre = lireTexte("Titre à rechercher :")
            if let livre = biblio.rechercherLivre(titre: titre) {
                livre.afficherInformations()
            } else {
                print("Aucun livre trouvé avec ce titre.")
            }
        case "0":
            retour = true
        default:
            print("Choix invalide, entrez 0, 1, 2 ou 3.")
        }
    }
}

// ---------- 2. Gestion des livres ----------
func menuLivres() {
    var retour = false
    while !retour {
        print("""

        --- Gestion des livres ---
        1. Afficher les informations d'un livre
        0. Retour au menu principal
        """)
        switch lireTexte("Votre choix :") {
        case "1":
            choisirLivre()?.afficherInformations()
        case "0":
            retour = true
        default:
            print("Choix invalide, entrez 0 ou 1.")
        }
    }
}

// ---------- 3. Gestion des adhérents ----------
func menuAdherents() {
    var retour = false
    while !retour {
        print("""

        --- Gestion des adhérents ---
        1. Créer un adhérent
        2. Emprunter un livre
        3. Retourner un livre
        4. Afficher les emprunts d'un adhérent
        0. Retour au menu principal
        """)
        switch lireTexte("Votre choix :") {
        case "1":
            let nom = lireTexte("Nom du nouvel adhérent :")
            // Le message d'erreur est affiché par l'init si le nom est invalide
            guard let a = Adherent(nom: nom) else { break }
            if adherents.contains(where: { $0.nom.lowercased() == a.nom.lowercased() }) {
                print("Cet adhérent existe déjà.")
            } else {
                adherents.append(a)
                print("Adhérent « \(a.nom) » créé.")
            }
        case "2":
            guard let a = choisirAdherent(), let livre = choisirLivre() else { break }
            a.emprunterLivre(livre)
        case "3":
            guard let a = choisirAdherent(), let livre = choisirLivre() else { break }
            a.retournerLivre(livre)
        case "4":
            choisirAdherent()?.afficherEmprunts()
        case "0":
            retour = true
        default:
            print("Choix invalide, entrez 0, 1, 2, 3 ou 4.")
        }
    }
}

// ---------- Menu principal ----------
func afficherMenuPrincipal() {
    print("""

    ===== BIBLIOTHÈQUE CHCL =====
    1. Gestion de la bibliothèque
    2. Gestion des livres
    3. Gestion des adhérents
    0. Quitter l'application
    """)
}

var continuer = true
while continuer {
    afficherMenuPrincipal()
    switch lireTexte("Votre choix :") {
    case "1": menuBibliotheque()
    case "2": menuLivres()
    case "3": menuAdherents()
    case "0":
        print("Au revoir !")
        continuer = false
    default:
        print("Choix invalide, entrez 0, 1, 2 ou 3.")
    }
}