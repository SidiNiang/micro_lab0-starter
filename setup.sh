#!/bin/bash

# Script de démarrage pour le TP0: Analyse et Refactoring SOLID
# Dr. El Hadji Bassirou TOURE
# Université Cheikh Anta Diop - DMI/FST

echo "Création du projet d'application monolithique de gestion de bibliothèque..."

# Création du répertoire principal
mkdir -p arch_log_seance1_starter
cd arch_log_seance1_starter

# Création des fichiers de configuration gradle
cat > build.gradle << 'EOF'
plugins {
    id 'org.springframework.boot' version '3.2.0'
    id 'io.spring.dependency-management' version '1.1.4'
    id 'java'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    runtimeOnly 'com.h2database:h2'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

test {
    useJUnitPlatform()
}
EOF

cat > settings.gradle << 'EOF'
rootProject.name = 'library'
EOF

# Création de l'arborescence du projet
mkdir -p src/main/java/com/example/library/{controller,model,repository,service}
mkdir -p src/main/resources

# Création du fichier d'application principale
cat > src/main/java/com/example/library/LibraryApplication.java << 'EOF'
package com.example.library;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import com.example.library.model.*;
import com.example.library.repository.*;
import java.time.LocalDate;

@SpringBootApplication
public class LibraryApplication {

    public static void main(String[] args) {
        SpringApplication.run(LibraryApplication.class, args);
    }
    
    @Bean
    public CommandLineRunner dataLoader(BookRepository bookRepository, 
                                       MemberRepository memberRepository,
                                       LoanRepository loanRepository) {
        return args -> {
            // Ajout de quelques livres de démonstration
            Book book1 = new Book("Introduction aux Microservices", "Sam Newman", "978-1491950357", 2019);
            Book book2 = new Book("Clean Code", "Robert C. Martin", "978-0132350884", 2008);
            Book book3 = new Book("Design Patterns", "Erich Gamma", "978-0201633610", 1994);
            
            bookRepository.save(book1);
            bookRepository.save(book2);
            bookRepository.save(book3);
            
            // Ajout de quelques membres
            Member member1 = new Member("Jean Dupont", "jean.dupont@email.com", "0123456789");
            Member member2 = new Member("Marie Martin", "marie.martin@email.com", "0987654321");
            
            memberRepository.save(member1);
            memberRepository.save(member2);
            
            // Création d'un prêt
            Loan loan = new Loan();
            loan.setBookId(book1.getId());
            loan.setMemberId(member1.getId());
            loan.setLoanDate(LocalDate.now().minusDays(7));
            loan.setDueDate(LocalDate.now().plusDays(7));
            
            loanRepository.save(loan);
        };
    }
}
EOF

# Création des fichiers de modèles
cat > src/main/java/com/example/library/model/Book.java << 'EOF'
package com.example.library.model;

import jakarta.persistence.*;

@Entity
@Table(name = "books")
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String author;
    private String isbn;
    private int publicationYear;
    
    public Book() {
    }
    
    public Book(String title, String author, String isbn, int publicationYear) {
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.publicationYear = publicationYear;
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getAuthor() {
        return author;
    }
    
    public void setAuthor(String author) {
        this.author = author;
    }
    
    public String getIsbn() {
        return isbn;
    }
    
    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }
    
    public int getPublicationYear() {
        return publicationYear;
    }
    
    public void setPublicationYear(int publicationYear) {
        this.publicationYear = publicationYear;
    }
}
EOF

cat > src/main/java/com/example/library/model/Member.java << 'EOF'
package com.example.library.model;

import jakarta.persistence.*;

@Entity
@Table(name = "members")
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String email;
    private String phone;
    
    public Member() {
    }
    
    public Member(String name, String email, String phone) {
        this.name = name;
        this.email = email;
        this.phone = phone;
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
}
EOF

cat > src/main/java/com/example/library/model/Loan.java << 'EOF'
package com.example.library.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "loans")
public class Loan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long bookId;
    private Long memberId;
    private LocalDate loanDate;
    private LocalDate dueDate;
    private LocalDate returnDate;
    
    public Loan() {
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getBookId() {
        return bookId;
    }
    
    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }
    
    public Long getMemberId() {
        return memberId;
    }
    
    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }
    
    public LocalDate getLoanDate() {
        return loanDate;
    }
    
    public void setLoanDate(LocalDate loanDate) {
        this.loanDate = loanDate;
    }
    
    public LocalDate getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }
    
    public LocalDate getReturnDate() {
        return returnDate;
    }
    
    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }
}
EOF

# Création des fichiers de repositories
cat > src/main/java/com/example/library/repository/BookRepository.java << 'EOF'
package com.example.library.repository;

import com.example.library.model.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {
}
EOF

cat > src/main/java/com/example/library/repository/MemberRepository.java << 'EOF'
package com.example.library.repository;

import com.example.library.model.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {
}
EOF

cat > src/main/java/com/example/library/repository/LoanRepository.java << 'EOF'
package com.example.library.repository;

import com.example.library.model.Loan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface LoanRepository extends JpaRepository<Loan, Long> {
    Optional<Loan> findByBookIdAndReturnDateIsNull(Long bookId);
}
EOF

# Création du service monolithique avec les problèmes SOLID
cat > src/main/java/com/example/library/service/LibraryService.java << 'EOF'
package com.example.library.service;

import com.example.library.model.Book;
import com.example.library.model.Member;
import com.example.library.model.Loan;
import com.example.library.repository.BookRepository;
import com.example.library.repository.MemberRepository;
import com.example.library.repository.LoanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class LibraryService {

    private final BookRepository bookRepository;
    private final MemberRepository memberRepository;
    private final LoanRepository loanRepository;
    
    @Autowired
    public LibraryService(BookRepository bookRepository, 
                         MemberRepository memberRepository,
                         LoanRepository loanRepository) {
        this.bookRepository = bookRepository;
        this.memberRepository = memberRepository;
        this.loanRepository = loanRepository;
    }
    
    // ---- Book Management ----
    
    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }
    
    public Book getBookById(Long id) {
        return bookRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Book not found"));
    }
    
    public Book createBook(Book book) {
        return bookRepository.save(book);
    }
    
    public Book updateBook(Long id, Book bookDetails) {
        Book book = getBookById(id);
        book.setTitle(bookDetails.getTitle());
        book.setAuthor(bookDetails.getAuthor());
        book.setIsbn(bookDetails.getIsbn());
        book.setPublicationYear(bookDetails.getPublicationYear());
        return bookRepository.save(book);
    }
    
    public void deleteBook(Long id) {
        Book book = getBookById(id);
        bookRepository.delete(book);
    }
    
    // ---- Member Management ----
    
    public List<Member> getAllMembers() {
        return memberRepository.findAll();
    }
    
    public Member getMemberById(Long id) {
        return memberRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Member not found"));
    }
    
    public Member createMember(Member member) {
        return memberRepository.save(member);
    }
    
    public Member updateMember(Long id, Member memberDetails) {
        Member member = getMemberById(id);
        member.setName(memberDetails.getName());
        member.setEmail(memberDetails.getEmail());
        member.setPhone(memberDetails.getPhone());
        return memberRepository.save(member);
    }
    
    public void deleteMember(Long id) {
        Member member = getMemberById(id);
        memberRepository.delete(member);
    }
    
    // ---- Loan Management ----
    
    public List<Loan> getAllLoans() {
        return loanRepository.findAll();
    }
    
    public Loan getLoanById(Long id) {
        return loanRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Loan not found"));
    }
    
    public Loan createLoan(Loan loan) {
        // Validation: Check if book exists
        Book book = getBookById(loan.getBookId());
        
        // Validation: Check if member exists
        Member member = getMemberById(loan.getMemberId());
        
        // Validation: Check if book is already loaned
        Optional<Loan> existingLoan = loanRepository.findByBookIdAndReturnDateIsNull(loan.getBookId());
        if (existingLoan.isPresent()) {
            throw new RuntimeException("Book is already loaned");
        }
        
        // Set loan dates
        loan.setLoanDate(LocalDate.now());
        loan.setDueDate(LocalDate.now().plusDays(14)); // 2 weeks loan period
        
        // Save and return the loan
        return loanRepository.save(loan);
    }
    
    public Loan returnBook(Long loanId) {
        Loan loan = getLoanById(loanId);
        
        if (loan.getReturnDate() != null) {
            throw new RuntimeException("Book already returned");
        }
        
        loan.setReturnDate(LocalDate.now());
        
        // Send notification to member
        Member member = getMemberById(loan.getMemberId());
        Book book = getBookById(loan.getBookId());
        sendNotification(member, "Thank you for returning '" + book.getTitle() + "'.");
        
        return loanRepository.save(loan);
    }
    
    // ---- Notification Logic ----
    
    public void sendNotification(Member member, String message) {
        // This is a simulation of sending notification
        System.out.println("Notification to " + member.getName() + " (" + member.getEmail() + "): " + message);
    }
    
    // This method mixes book management with notification, violating SRP
    public void notifyDueBooks() {
        LocalDate today = LocalDate.now();
        
        List<Loan> loans = loanRepository.findAll();
        
        for (Loan loan : loans) {
            if (loan.getReturnDate() == null && loan.getDueDate().isBefore(today)) {
                Member member = getMemberById(loan.getMemberId());
                Book book = getBookById(loan.getBookId());
                
                sendNotification(
                    member, 
                    "The book '" + book.getTitle() + "' is overdue. Please return it as soon as possible."
                );
            }
        }
    }
}
EOF

# Création des contrôleurs
cat > src/main/java/com/example/library/controller/BookController.java << 'EOF'
package com.example.library.controller;

import com.example.library.model.Book;
import com.example.library.service.LibraryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {

    private final LibraryService libraryService;
    
    @Autowired
    public BookController(LibraryService libraryService) {
        this.libraryService = libraryService;
    }
    
    @GetMapping
    public List<Book> getAllBooks() {
        return libraryService.getAllBooks();
    }
    
    @GetMapping("/{id}")
    public Book getBookById(@PathVariable Long id) {
        return libraryService.getBookById(id);
    }
    
    @PostMapping
    public Book createBook(@RequestBody Book book) {
        return libraryService.createBook(book);
    }
    
    @PutMapping("/{id}")
    public Book updateBook(@PathVariable Long id, @RequestBody Book book) {
        return libraryService.updateBook(id, book);
    }
    
    @DeleteMapping("/{id}")
    public void deleteBook(@PathVariable Long id) {
        libraryService.deleteBook(id);
    }
}
EOF

cat > src/main/java/com/example/library/controller/MemberController.java << 'EOF'
package com.example.library.controller;

import com.example.library.model.Member;
import com.example.library.service.LibraryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/members")
public class MemberController {

    private final LibraryService libraryService;
    
    @Autowired
    public MemberController(LibraryService libraryService) {
        this.libraryService = libraryService;
    }
    
    @GetMapping
    public List<Member> getAllMembers() {
        return libraryService.getAllMembers();
    }
    
    @GetMapping("/{id}")
    public Member getMemberById(@PathVariable Long id) {
        return libraryService.getMemberById(id);
    }
    
    @PostMapping
    public Member createMember(@RequestBody Member member) {
        return libraryService.createMember(member);
    }
    
    @PutMapping("/{id}")
    public Member updateMember(@PathVariable Long id, @RequestBody Member member) {
        return libraryService.updateMember(id, member);
    }
    
    @DeleteMapping("/{id}")
    public void deleteMember(@PathVariable Long id) {
        libraryService.deleteMember(id);
    }
}
EOF

cat > src/main/java/com/example/library/controller/LoanController.java << 'EOF'
package com.example.library.controller;

import com.example.library.model.Loan;
import com.example.library.service.LibraryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/loans")
public class LoanController {

    private final LibraryService libraryService;
    
    @Autowired
    public LoanController(LibraryService libraryService) {
        this.libraryService = libraryService;
    }
    
    @GetMapping
    public List<Loan> getAllLoans() {
        return libraryService.getAllLoans();
    }
    
    @GetMapping("/{id}")
    public Loan getLoanById(@PathVariable Long id) {
        return libraryService.getLoanById(id);
    }
    
    @PostMapping
    public Loan createLoan(@RequestBody Loan loan) {
        return libraryService.createLoan(loan);
    }
    
    @PutMapping("/{id}/return")
    public Loan returnBook(@PathVariable Long id) {
        return libraryService.returnBook(id);
    }
}
EOF

# Création du fichier d'application.properties
cat > src/main/resources/application.properties << 'EOF'
# Configuration H2 Database
spring.datasource.url=jdbc:h2:mem:librarydb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# Configuration JPA
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Configuration Server
server.port=8080
EOF

# Télécharger Gradle Wrapper
mkdir -p gradle/wrapper
curl -L -o gradle/wrapper/gradle-wrapper.jar https://repo.maven.apache.org/maven2/org/gradle/gradle-wrapper/8.1.1/gradle-wrapper-8.1.1.jar
curl -L -o gradle/wrapper/gradle-wrapper.properties https://raw.githubusercontent.com/gradle/gradle/v8.1.1/gradle/wrapper/gradle-wrapper.properties

# Création du fichier Dockerfile avec une construction multi-étapes
cat > Dockerfile << 'EOF'
FROM openjdk:17-jdk-slim AS build

WORKDIR /app

# Copier les fichiers de projet Gradle
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY gradlew ./
COPY src ./src

# Donner les permissions d'exécution au script gradlew
RUN chmod +x ./gradlew

# Construire l'application
RUN ./gradlew build --no-daemon

FROM openjdk:17-jdk-slim

WORKDIR /app

# Copier le JAR depuis l'étape de construction
COPY --from=build /app/build/libs/library-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

# Création du fichier docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'

services:
  library-app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:h2:mem:librarydb
    networks:
      - library-network

networks:
  library-network:
    driver: bridge
EOF

# Création des scripts de démarrage
cat > gradlew << 'EOF'
#!/bin/sh
exec java -jar gradle/wrapper/gradle-wrapper.jar "$@"
EOF
chmod +x gradlew

cat > gradlew.bat << 'EOF'
@echo off
java -jar gradle\wrapper\gradle-wrapper.jar %*
EOF

# Ajout du README.md avec les instructions
cat > README.md << 'EOF'
# Application de Gestion de Bibliothèque

Ce projet est une application monolithique de gestion de bibliothèque qui permet de :
- Gérer un catalogue de livres (ajout, modification, suppression)
- Gérer les membres de la bibliothèque
- Enregistrer les prêts et retours de livres
- Envoyer des notifications (simulées) aux membres

Cette application est volontairement conçue avec plusieurs problèmes architecturaux liés aux principes SOLID, destinés à être identifiés et corrigés dans le cadre d'un exercice de refactoring.

## Prérequis

- JDK 17+
- Gradle (inclus via le wrapper)
- Git
- Docker et Docker Compose (optionnel, pour exécuter l'application dans un conteneur)

## Installation et démarrage

### Option 1: Exécution locale

1. Clonez le dépôt :
   ```
   git clone https://github.com/elbachir67/micro_lab0-starter.git
   ```

2. Accédez au répertoire du projet :
   ```
   cd micro_lab0-starter
   ```

3. Lancez l'application avec Gradle :
   ```
   ./gradlew bootRun
   ```

### Option 2: Exécution avec Docker

1. Clonez le dépôt :
   ```
   git clone https://github.com/elbachir67/micro_lab0-starter.git
   ```

2. Accédez au répertoire du projet :
   ```
   cd micro_lab0-starter
   ```

3. Lancez l'application avec Docker Compose :
   ```
   docker-compose up --build
   ```

## Endpoints API

L'application expose les endpoints REST suivants :

- **Livres** :
  - GET `/api/books` - Liste tous les livres
  - GET `/api/books/{id}` - Obtient un livre par son ID
  - POST `/api/books` - Crée un nouveau livre
  - PUT `/api/books/{id}` - Met à jour un livre existant
  - DELETE `/api/books/{id}` - Supprime un livre

- **Membres** :
  - GET `/api/members` - Liste tous les membres
  - GET `/api/members/{id}` - Obtient un membre par son ID
  - POST `/api/members` - Crée un nouveau membre
  - PUT `/api/members/{id}` - Met à jour un membre existant
  - DELETE `/api/members/{id}` - Supprime un membre

- **Prêts** :
  - GET `/api/loans` - Liste tous les prêts
  - GET `/api/loans/{id}` - Obtient un prêt par son ID
  - POST `/api/loans` - Crée un nouveau prêt
  - PUT `/api/loans/{id}/return` - Enregistre le retour d'un livre

## Base de données

L'application utilise une base de données H2 en mémoire. La console H2 est accessible à l'URL :
```
http://localhost:8080/h2-console
```

Paramètres de connexion :
- JDBC URL: `jdbc:h2:mem:librarydb`
- Username: `sa`
- Password: (laisser vide)

## Structure du Projet

```
src/main/java/com/example/library/
|-- LibraryApplication.java
|-- controller/
|   |-- BookController.java
|   |-- MemberController.java
|   `-- LoanController.java
|-- model/
|   |-- Book.java
|   |-- Member.java
|   `-- Loan.java
|-- repository/
|   |-- BookRepository.java
|   |-- MemberRepository.java
|   `-- LoanRepository.java
`-- service/
    `-- LibraryService.java
```

## Notes sur le Design

Cette application présente plusieurs problèmes architecturaux volontaires liés aux principes SOLID :

1. La classe `LibraryService` viole le principe de responsabilité unique (SRP) en gérant plusieurs domaines (livres, membres, prêts, notifications).

2. Il y a un fort couplage entre les différentes fonctionnalités.

3. Les contrôleurs ont une dépendance directe vers l'implémentation du service plutôt que vers des interfaces (violation du DIP).

4. La logique de notification est mélangée avec la logique métier.

Ces problèmes sont destinés à être identifiés et corrigés dans le cadre d'un exercice de refactoring.
EOF

# Création du fichier .gitignore
cat > .gitignore << 'EOF'
HELP.md
.gradle
build/
!gradle/wrapper/gradle-wrapper.jar
!**/src/main/**/build/
!**/src/test/**/build/

### STS ###
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache
bin/
!**/src/main/**/bin/
!**/src/test/**/bin/

### IntelliJ IDEA ###
.idea
*.iws
*.iml
*.ipr
out/
!**/src/main/**/out/
!**/src/test/**/out/

### NetBeans ###
/nbproject/private/
/nbbuild/
/dist/
/nbdist/
/.nb-gradle/

### VS Code ###
.vscode/

### Mac OS ###
.DS_Store
EOF

# Initialisation du dépôt Git
git init
git add .
git commit -m "Initial commit: monolithic library application"

echo "Script terminé avec succès! Voici les prochaines étapes:"
echo "1. Aller dans le dossier: cd arch_log_seance1_starter"
echo "2. Option locale: Lancer l'application avec ./gradlew bootRun"
echo "3. Option Docker: Lancer avec docker-compose up --build"
echo "4. Accéder à l'API via: http://localhost:8080/api/books"
echo ""
echo "Pour publier sur GitHub:"
echo "1. Créer un nouveau dépôt sur GitHub: https://github.com/elbachir67/micro_lab0-starter.git"
echo "2. Connecter votre dépôt local:"
echo "   git remote add origin https://github.com/elbachir67/micro_lab0-starter.git"
echo "   git push -u origin master"
echo ""
echo "Le projet est prêt pour le TP0 sur l'application des principes SOLID!"
