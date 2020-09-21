import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static private let baseUrl = URL(string: "https://swapi.dev/api")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseUrl = baseUrl else { return completion(nil) }
        
        let finalUrl = baseUrl.appendingPathComponent("/people/\(id)")
        
        URLSession.shared.dataTask(with: finalUrl) { (data, _, error) in
            if let error = error {
                print("Error performing data task: \(error)")
                completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let jsonDecoder = JSONDecoder()
                let person = try jsonDecoder.decode(Person.self, from: data)
                completion(person)
            } catch {
                print("Error decoding json into Person struct: \(error)")
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error performing data task: \(error)")
                completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let jsonDecoder = JSONDecoder()
                let film = try jsonDecoder.decode(Film.self, from: data)
                completion(film)
            } catch {
                print("Error decoding json into Film struct: \(error)")
            }
            
        }.resume()
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film.title)
            print("-----------------------------")
            print(film.opening_crawl)
            print("\n\n\n\n")
        }
    }
}

SwapiService.fetchPerson(id: 1) { (person) in
    if let person = person {
        for filmUrl in person.films {
            fetchFilm(url: filmUrl)
        }
    }
}
