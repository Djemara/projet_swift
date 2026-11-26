import Foundation

class Bibliotheque {
    private var _livres: [Livre] = []

    // Getter seulement : on ajoute via ajouterLivre()
    var livres: [Livre] {
        get { return _livres }
    }

    func ajouterLivre(_ livre: Livre) {
        let dejaPresent = _livres.contains {
            $0.titre.lowercased() == livre.titre.lowercased()
                && $0.auteur.lowercased() == livre.auteur.lowercased()
                && type(of: $0) == type(of: livre)
        }
        guard !dejaPresent else {
            print("Ce livre existe déjà dans le catalogue (même titre, même auteur, même type).")
            return
        }
        _livres.append(livre)
        print("« \(livre.titre) » a été ajouté au catalogue.")
    }

    func afficherCatalogue() {
        guard !_livres.isEmpty else {
            print("Le catalogue est vide.")
            return
        }
        print("===== CATALOGUE =====")
        for livre in _livres {
            livre.afficherInformations()
            print("---------------------")
        }
    }

    func rechercherLivre(titre: String) -> Livre? {
        return rechercherLivres(titre: titre).first
    }

    func rechercherLivres(titre: String) -> [Livre] {
        let recherche = titre.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return _livres.filter { $0.titre.lowercased() == recherche }
    }
}