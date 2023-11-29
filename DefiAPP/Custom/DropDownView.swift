//
//  DropDownView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/23.
//

import UIKit

class DropDownView: UIView {
    
    var headerBtn = UIButton()
    
    var headerSelected = false
    
    var shapeLayer = CAShapeLayer()
    
    var openMenuClosure: BoolClosure?
    
    var cellClickClosure: StringClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (headerSelected) {
            let totalHeight = CGFloat(self.datas.count + 1) * self.rowHeight
            self.frame.size.height = totalHeight > 350 ? 350 : totalHeight
        }else {
            self.frame.size.height = self.rowHeight
        }
    }
    
    func setUI() {
        //self.backgroundColor = UIColor.gray
        self.layer.borderColor = UIColor(hex: "#00000026")?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6
        self.addSubview(self.listTable)
        
        listTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        listTable.topAnchor.constraint(equalTo: self.topAnchor),
        listTable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        listTable.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        listTable.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
        
    }
    
    //MARK: - Pravite Method
    func createIndicator(withColor color: UIColor, andPosition point: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 12, y: 0))
        path.addLine(to: CGPoint(x: 6, y: 7))
        path.close()

        layer.path = path.cgPath
        layer.lineWidth = 1.0
        layer.fillColor = color.cgColor

        let bound = layer.path?.copy(strokingWithWidth: layer.lineWidth, lineCap: .butt, lineJoin: .miter, miterLimit: layer.miterLimit)
        layer.bounds = bound?.boundingBoxOfPath ?? CGRect.zero

        layer.position = point

        return layer
    }
    
    func animateIndicator(_ indicator: CAShapeLayer, forward: Bool, complete: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))

        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.values = forward ? [0, Double.pi] : [Double.pi, 0]
        if anim.isRemovedOnCompletion == false {
            indicator.add(anim, forKey: anim.keyPath)
        } else {
            indicator.add(anim, forKey: anim.keyPath)
            indicator.setValue(anim.values?.last, forKeyPath: anim.keyPath ?? "")
        }
        CATransaction.commit()

        complete()
    }
    
    func cellInsertOrDelete(insert: Bool) {
        self.listTable.beginUpdates()
        
        var indexPaths: [IndexPath] = []
        for (idx, _) in self.datas.enumerated() {
            let indePath = IndexPath(row: idx, section: 0)
            indexPaths.append(indePath)
        }
        
        if (insert) {
            self.listTable.insertRows(at: indexPaths, with: .top)
        }else {
            self.listTable.deleteRows(at: indexPaths, with: .bottom)
        }
        
        self.listTable.endUpdates()
    }
    
    func closeMenu() {
        if (self.headerSelected) {
            self.sectionHeaderClicked()
        }
    }
    
    //MARK: - action
    @objc func sectionHeaderClicked() {
        self.headerSelected = !self.headerSelected
        self.openMenuClosure?(self.headerSelected)
        
        self.setNeedsLayout()
            
        self.animateIndicator(self.shapeLayer, forward: self.headerSelected) { [weak self] in
            guard let self else { return }
            self.cellInsertOrDelete(insert: self.headerSelected)
            self.headerBtn.layer.borderWidth = self.headerSelected ? 1:0
        }
        
    }
    
    
    // MARK: - Getters/Setters/Lazy
    lazy var listTable: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 35), style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset = .zero
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    var datas: [String] = [] {
        didSet {
            self.listTable.reloadData()
        }
    }
    
    var rowHeight: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
}

//MARK: - TableViewDelegate
extension DropDownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headerSelected ? self.datas.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.datas[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.headerBtn.setTitle(self.datas[indexPath.row], for: .normal)
        self.closeMenu()
        
        self.cellClickClosure?(self.datas[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.rowHeight == 0 ? 35 : self.rowHeight))
        headerBtn.setTitle(self.datas[0], for: .normal)
        headerBtn.setTitleColor(.black, for: .normal)
        headerBtn.titleLabel?.font = .systemFont(ofSize: 14)
        headerBtn.backgroundColor = .white
        headerBtn.addTarget(self, action: #selector(sectionHeaderClicked), for: .touchUpInside)
        let position = CGPoint(x: headerBtn.frame.width - 20, y: headerBtn.frame.height / 2)
        let shapeLayer = createIndicator(withColor: .black, andPosition: position)
        headerBtn.layer.addSublayer(shapeLayer)
        self.headerBtn = headerBtn
        self.shapeLayer = shapeLayer
        return headerBtn
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight == 0 ? 35 : self.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.rowHeight == 0 ? 35 : self.rowHeight
    }
    
}
