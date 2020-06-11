//
//  ViewController.swift
//  iConverter 2.0
//
//  Created by Admin on 10.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var exchange = Dictionary<String,Double>()
    var currencyPicker = UIPickerView()
    var currencies = ["EUR"]
    @IBOutlet weak var fromValue: UITextField!
    @IBOutlet weak var fromCurrency: UITextField!
    @IBOutlet weak var toValue: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var toCurrency: UITextField!
    @IBAction func convertButton(_ sender: UIButton) {
        
        let fromineuros = (Double(fromValue.text!)!) / exchange[fromCurrency.text!]! as Double
        let result = fromineuros * exchange[toCurrency.text!]! as Double
        toValue.text = String(format: "%.2f",result)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        convertButton.layer.cornerRadius = 20.0

        convertButton.layer.borderWidth = 2
        convertButton.layer.borderColor = (UIColor(red: 237/255, green: 237/255, blue: 238/255, alpha: 1.0)).cgColor
        let apiurl = URL(string: "https://api.exchangeratesapi.io/latest")
        let get = URLSession.shared.dataTask(with: apiurl!) {(data, response, error) in
            if let content = data {
                do {
                    let notsortedrates = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    if let rates = notsortedrates["rates"] as? NSDictionary {
                        self.exchange["EUR"] = (1)
                        
                        for (key,value) in rates {
                            self.currencies.append(key as! String)
                            self.exchange[(key as! String)] = (value as! Double)
                        }
                        
                    }
                    

                } catch {
                    
                }
                }
        }
        get.resume()
        currencyPicker.delegate = self
        currencyPicker.dataSource=self
        fromCurrency.inputView = currencyPicker
        toCurrency.inputView = currencyPicker
        
    }
    
    //Закрыть клавиатуру
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if fromCurrency.isFirstResponder {
            fromCurrency.text = currencies[row]
        } else if toCurrency.isFirstResponder {
            toCurrency.text = currencies[row]
        }
        
        
    }



}

