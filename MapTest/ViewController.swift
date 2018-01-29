//
//  ViewController.swift
//  MapTest
//
//  Created by Maciej Koziel on 26/01/2018.
//  Copyright © 2018 Maciej Koziel. All rights reserved.
//

import MapKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let mapView = MKMapView()
    let drawButton = UIButton()
    let disposeBag = DisposeBag()
    var renderer: MKPolygonRenderer = MKPolygonRenderer()
    let drawView = DrawView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        view.addSubview(drawView)
        view.addSubview(drawButton)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        drawButton.setTitle("Draw", for: .normal)
        drawButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        drawButton.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(30.0)
            make.width.equalTo(120.0)
            make.height.equalTo(44.0)
        }
        
        drawView.delegate = self
        drawView.isHidden = true
        drawView.snp.makeConstraints { make in
            make.edges.equalTo(mapView)
        }
        
        drawButton.rx.tap
            .bind(onNext: tapped)
            .disposed(by: disposeBag)
        
        mapView.delegate = self
    }
    
    private func tapped() {
        if drawView.isHidden {
            drawButton.setTitle("End drawing", for: .normal)
        } else {
            drawButton.setTitle("Draw", for: .normal)
        }
        drawView.isHidden = !drawView.isHidden
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return renderer
    }
}

extension ViewController: DrawViewDelegate {
    func drawView(view: DrawView, didCompletedDrawing points: [CGPoint]) {
        guard points.count > 2 else {
            return
        }
        
        var locations = points.map { mapView.convert($0, toCoordinateFrom: mapView) }
        let polygon = MKPolygon(coordinates: &locations, count: locations.count)
        
        renderer = MKPolygonRenderer(polygon: polygon)
        renderer.fillColor = UIColor.blue.withAlphaComponent(0.3)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 1
        
        mapView.add(polygon)
    }
}
