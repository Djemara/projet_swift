import Foundation

class LivreNumerique: Livre {
    private var _tailleFichierMo: Int

    var tailleFichierMo: Int {
        get { return _tailleFichierMo }
        set {
            if newValue > 0 {
                _tailleFichierMo = newValue
            } else {
                print("Erreur : la taille du fichier doit être supérieure à 0.")
            }
        }
    }

    init?(titre: String, auteur: String, tailleFichierMo: Int) {
        guard tailleFichierMo > 0 else {
            print("Erreur : la taille du fichier doit être supérieure à 0.")
            return nil
        }
        self._tailleFichierMo = tailleFichierMo
        super.init(titre: titre, auteur: auteur)
    }

    override func afficherInformations() {
        super.afficherInformations()
        print("Type : livre numérique")
        print("Taille du fichier : \(tailleFichierMo) Mo")
    }
}