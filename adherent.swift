import Foundation

class Adherent {
    // Données privées
    private var _nom: String
    private var _livresEmpruntes: [Livre] = []
    private let maxEmprunts = 3

    // Getter + setter avec validation
    var nom: String {
        get { return _nom }
        set {
            if Adherent.nomValide(newValue) {
                _nom = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                print("Erreur : nom invalide, modification refusée.")
            }
        }
    }

    // Getter seulement : lecture seule depuis l'extérieur
    var livresEmpruntes: [Livre] {
        get { return _livresEmpruntes }
    }

    // Vérification réutilisable (init et setter)
    static func nomValide(_ nom: String) -> Bool {
        let n = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !n.isEmpty else { return false }
        let autorises = CharacterSet.letters
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "'’-"))
        return n.unicodeScalars.allSatisfy { autorises.contains($0) }
    }

    init?(nom: String) {
        guard Adherent.nomValide(nom) else {
            print("Erreur : le nom ne peut pas être vide et ne doit contenir que des lettres.")
            return nil
        }
        self._nom = nom.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func emprunterLivre(_ livre: Livre) {
        guard _livresEmpruntes.count < maxEmprunts else {
            print("\(nom) a déjà \(maxEmprunts) livres : emprunt impossible.")
            return
        }
        if livre.emprunter() {
            _livresEmpruntes.append(livre)
            print("\(nom) a emprunté « \(livre.titre) ».")
        }
    }

    func retournerLivre(_ livre: Livre) {
        guard let index = _livresEmpruntes.firstIndex(where: { $0 === livre }) else {
            print("\(nom) n'a pas emprunté « \(livre.titre) ».")
            return
        }
        livre.retourner()
        _livresEmpruntes.remove(at: index)
        print("\(nom) a retourné « \(livre.titre) ».")
    }

    func afficherEmprunts() {
        if _livresEmpruntes.isEmpty {
            print("\(nom) n'a aucun livre emprunté.")
        } else {
            print("Livres empruntés par \(nom) :")
            _livresEmpruntes.forEach { $0.afficherInformations() }
        }
    }
}