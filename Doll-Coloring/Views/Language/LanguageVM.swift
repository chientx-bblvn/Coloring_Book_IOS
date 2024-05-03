//
//  LanguageVM.swift
//  Doll-Coloring
//
//  Created by BBLabs on 13/08/2023.
//

import RxSwift

class LanguageVM {
    
    static let shared = LanguageVM()
    
    private let disposeBag = DisposeBag()

    var listCountryCode: [Language] = Language.allCases

}
