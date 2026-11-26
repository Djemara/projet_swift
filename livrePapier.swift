import Foundation

class LivrePapier: Livre {
    private var _nombrePages: Int

    // Getter + setter avec validation
    var nombrePages: Int {
        get { return _nombrePages }
        set {
            if newValue > 0 {
                _nombrePages = newValue
            } else {
                print("Erreur : le nombre de pages doit être supérieur à 0.")
            }
        }
    }

    init?(titre: String, auteur: String, nombrePages: Int) {
        guard nombrePages > 0 else {
            print("Erreur : le nombre de pages doit être supérieur à 0.")
            return nil
        }
        self._nombrePages = nombrePages
        super.init(titre: titre, auteur: auteur)
    }

    override func afficherInformations() {
        super.afficherInformations()
        print("Type : livre papier")
        print("Nombre de pages : \(nombrePages)")
    }
}