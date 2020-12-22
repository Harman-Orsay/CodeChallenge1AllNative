//
//  SortFieldsViewModel.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 22/12/20.
//

import Foundation
import Combine
import CodeChallengeModel


class SortFieldsViewModel {
    
    let fields = User.SortableField.all
    @Published var selectedField: User.SortableField
    var responder: SortFieldSelectionResponder
    
    init(currentSortField: User.SortableField, responder: SortFieldSelectionResponder) {
        self.selectedField = currentSortField
        self.responder = responder
    }
    
    @objc func doneAction() {
        responder.selected(field: selectedField)
    }
}

protocol SortFieldSelectionResponder {
    func selected(field: User.SortableField)
}
