//
//  FileManagerViewController.swift
//  scrollView
//
//  Created by Egor Devyatov on 05.08.2019.
//  Copyright © 2019 Egor Devyatov. All rights reserved.
//

import UIKit
import FileProvider

class FileManagerViewController: UIViewController {
    
    let fileManager = FileManager() // определили файл манаждер
    let tempDir = NSTemporaryDirectory() // temp directory

    let fileName = "file.txt" // имя файла
    
    var paths: [String] = []

    @IBOutlet weak var fmTextView: UITextView! // поле вывода текста из файла
    
    @IBOutlet weak var textField: UITextField! // поле ввода текста
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User name: \(NSUserName())")
        print("home dir: \(NSHomeDirectory())")
        print("Current dir path: \(fileManager.currentDirectoryPath)")
        print("Temp dir: \(tempDir)")
        paths = fileManager.subpaths(atPath: tempDir) ?? ["no paths"]
        for path in paths {
            print(path)
        }
        let tempDirURL = URL(fileURLWithPath: tempDir)
        print("URL temp dir: \(tempDirURL)")
    }
    
    // проверка что файл file.txt существует
    func checkDirectory() -> String? {
        do {
            let filesInDirectory = try fileManager.contentsOfDirectory(atPath: tempDir)
            
            let files = filesInDirectory
            if files.count > 0 {
                if files.first == fileName {
                    print("file.txt found")
                    return files.first
                } else {
                    print("File not found")
                    return nil
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    // Файл text.txt создается с контентом взятым из поля textEdit и записывается в каталог tempDir/ с методом writeToFile:atomically:encoding. Если у нас не получается с вами создать файл, то в консоль выводится ошибка.
    @IBAction func createFileTapButton(_ sender: UIButton) {
        let path = (tempDir as NSString).appendingPathComponent(fileName)
        
        if textField.text != nil {
            let contentsOfFile = textField.text
            // Записываем в файл
            do {
                try contentsOfFile?.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
                print("File text.txt created at temp directory")
            } catch let error as NSError {
                print("could't create file text.txt because of error: \(error)")
            }
        }
    }
    
    // Мы проверяем наличие файла file.txt в каталоге через метод checkDirectory(), если у нас есть этот файл,
    // то в directoryWithFiles присваивается возвращаемое значение метода checkDirectory(),
    // если же файла у нас не оказывается, то в directoryWithFiles присваивается строка "Empty" .
    // Оператор ??  это коалесцирующий nil оператор (или оператор объединяющий по nil),
    // работает он таким образом, что когда checkDirectory() будет равен nil,
    // то directoryWithFiles будет равен "Empty" , если же  checkDirectory() не будет равен nil
    // (то есть "file.txt" есть), то  в directoryWithFiles перейдет название файла "file.txt".
    // Значение directoryWithFiles будет выведено в консоль.
    @IBAction func viewDirectoryTapButton(_ sender: UIButton) {
        // Смотрим содержимое папки
        let directoryWithFiles = checkDirectory() ?? "Файлов нет. Пусто"
        let contentsOfDirectory = "Contents of Directory \(tempDir): \(directoryWithFiles)"
        print(contentsOfDirectory) // выведем в консоль
        fmTextView.text = contentsOfDirectory // выведем в поле fmTextView
        fmTextView.textColor = UIColor.blue
    }
    
    
    @IBAction func readFileTapButton(_ sender: UIButton) {
        // Читаем из файла
        let directoryWithFiles = checkDirectory() ?? "Файлов нет. Пусто"
        
        let path = (tempDir as NSString).appendingPathComponent(directoryWithFiles)
        
        do {
            let contentsOfFile = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            print("content of the file is: \(contentsOfFile)")
            
            // выводим содержимое файла в fmTextView
            fmTextView.text = contentsOfFile as String
            fmTextView.textColor = UIColor.blue
        // если ошибка то выводим ошибку
        } catch let error as NSError {
            print("there is an file reading error: \(error)")
        }
    }
    
    @IBAction func deleteButtonTap(_ sender: UIButton) {
        let directoryWithFiles = checkDirectory() ?? "Файлов нет. Пусто"
        do {
            let path = (tempDir as NSString).appendingPathComponent(directoryWithFiles)
            try fileManager.removeItem(atPath: path)
            print("file deleted")
        } catch let error as NSError {
            print("error occured while deleting file: \(error.localizedDescription)")
        }
    }
    
}
