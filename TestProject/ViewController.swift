//
//  ViewController.swift
//  TestProject
//
//  Created by Vaibhav Sadana on 01/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var columnsText: UITextField!
    @IBOutlet weak var rowsTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = 0
    var rows = 7
    var columns = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = columns * rows
        delegateSelf()
    }
    
    func delegateSelf(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
        columnsText.delegate = self
        rowsTF.delegate = self
        columnsText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        rowsTF.addTarget(self, action: #selector(textSearchFieldDidChange(_:)), for: .editingChanged)
        rowsTF.inputAccessoryView = toolBar()
        columnsText.inputAccessoryView = toolBar()
    }
    
    @objc func textFieldDidChange(_ textField : UITextField){
        columns = Int(textField.text ?? "") ?? 0
    }
    
    @objc func textSearchFieldDidChange(_ textField : UITextField){
        rows = Int(textField.text ?? "") ?? 0
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        items = rows * columns
        collectionView.collectionViewLayout = layout()
        collectionView.reloadData()
    }
}


extension ViewController :  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func layout()->UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute((collectionView.frame.width / CGFloat(rows))), heightDimension: .absolute((collectionView.frame.width / CGFloat(rows))))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        var groupSize :  NSCollectionLayoutGroup!
        groupSize = .horizontal(layoutSize: itemSize, repeatingSubitem: item, count: columns)
//        groupSize?.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: groupSize)
//        section.interGroupSpacing = 10
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let diag1 = (indexPath.item % (rows + 1)) == 0
        let diag2 = ((indexPath.row ) + (rows - 1))  % (rows - 1) == 0
        cell.contentView.backgroundColor =  diag1 ? .red : diag2 ? .red :  .blue
        cell.contentView.layer.borderColor =  UIColor.black.cgColor
        cell.contentView.layer.borderWidth = 5.0
        return cell
    }
}


extension ViewController : UITextFieldDelegate{
    func toolBar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = .lightGray
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let buttonTitle = "Done"
        let doneButton = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(didTapView))
        doneButton.tintColor = .black
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
}
