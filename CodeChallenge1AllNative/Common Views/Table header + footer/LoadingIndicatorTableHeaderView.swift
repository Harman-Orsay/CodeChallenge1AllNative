//
//  LoadingIndicatorTableHeaderView.swift
//  CodeChallenge1
//
//  Created by Rohan Ramsay on 21/10/20.
//  Copyright © 2020 Harman Orsay. All rights reserved.
//

import UIKit

class LoadingIndicatorTableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    var loadingState: LoadingHeaderState = .notVisible {
        
        didSet {
            
            self.alterUIBasedOn(state: self.loadingState)
        }
    }
    var section: Int = -1
    
    func alterUIBasedOn(state: LoadingHeaderState) {
        
        switch state {
            
        case .notVisible:
            
            self.indicatorView.isAnimating ? self.indicatorView.stopAnimating() : ()
            self.indicatorView.isHidden = true
            self.mainLabel.isHidden = true
            
        case .loading:
            
            self.indicatorView.isHidden = false
            self.indicatorView.isAnimating ? () : self.indicatorView.startAnimating()
            self.mainLabel.isHidden = true
            
        case .nothingToLoad:
            
            self.indicatorView.isAnimating ? self.indicatorView.stopAnimating() : ()
            self.indicatorView.isHidden = true
            self.mainLabel.isHidden = false
            self.mainLabel.text = "Nothing more to load"
            
        case .errored( let localizedMessage):
            
            self.indicatorView.isAnimating ? self.indicatorView.stopAnimating() : ()
            self.indicatorView.isHidden = true
            self.mainLabel.isHidden = false
            self.mainLabel.text = localizedMessage
        }
    }
    
    //MARK: - Load from NIB
    var view:UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    override public var intrinsicContentSize: CGSize {
        
        return CGSize(width: self.frame.width, height: self.view.intrinsicContentSize.height)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LoadingIndicatorTableHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func xibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.contentView.addSubview(view)
    }
}

enum LoadingHeaderState {
    
    case notVisible, loading, nothingToLoad, errored(String)
}
