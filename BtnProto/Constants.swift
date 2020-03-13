//
//  Constants.swift
//  BtnProto
//
//  Created by Tim Isaev on 12.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import UIKit


struct Constant {
    struct Dimension {
        static var btnSize: CGFloat {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 102
            }
            return 54
        }
        
        static var btnBottomHeight: CGFloat {
            return btnSize * 0.15
        }
        
        static var playRectEdge: CGFloat {
            return btnSize * 0.3
        }
        
        static var btnGap: CGFloat {
            return btnSize * 0.09
        }
        static var btnMainRadius: CGFloat {
            return btnSize * 0.17
        }
        
        static var btnInnerRadius: CGFloat {
            return btnSize * 0.14
        }
        
        static var btnBottomRadius: CGFloat {
            return btnSize * 0.19
        }
        static var btnEdgeThinckness: CGFloat {
            return btnSize * 0.1
        }
    }
}
