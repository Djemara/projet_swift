import Foundation

class Livre {
    private var _titre: String
    private var _auteur: String
    private var _estDisponible: Bool = true

    // Getters seulement : lecture seule
    var titre: String {
        get { return _titre }
    }
    var auteur: String {
        get { return _auteur }
    }
    var estDisponible: Bool {
        get { return _estDisponible }
    }

    static func titreValide(_ titre: String) -> Bool {
        return !titre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    static func auteurValide(_ auteur: String) -> Bool {
        let a = auteur.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !a.isEmpty else { return false }
        let autorises = CharacterSet.letters
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "'’-."))
        guard a.unicodeScalars.allSatisfy({ autorises.contains($0) }) else { return false }
        return a.unicodeScalars.contains { CharacterSet.letters.contains($0) }
    }

    init?(titre: String, auteur: String) {
        guard Livre.titreValide(titre) else {
            print("Erreur : le titre ne peut pas être vide.")
            return nil
        }
        guard Livre.auteurValide(auteur) else {
            print("Erreur : l'auteur ne peut pas être vide et ne doit contenir que des lettres.")
            return nil
        }
        self._titre = titre.trimmingCharacters(in: .whitespacesAndNewlines)
        self._auteur = auteur.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func afficherInformations() {
        print("Titre : \(titre)")
        print("Auteur : \(auteur)")
        print("Disponible : \(estDisponible ? "oui" : "non")")
    }

    func emprunter() -> Bool {
        guard _estDisponible else {
            print("« \(titre) » est déjà emprunté.")
            return false
        }
        _estDisponible = false
        return true
    }

    @discardableResult
    func retourner() -> Bool {
        guard !_estDisponible else {
            print("« \(titre) » n'a pas été emprunté, il est déjà disponible.")
            return false
        }
        _estDisponible = true
        return true
    }
}