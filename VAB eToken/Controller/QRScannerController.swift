//
//  QRScannerController.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/23/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class QRScannerController : BaseViewController {
    
    var scannerDelegate : QRScannerDelegate? = nil
    public static func setupQrScanner(context : BaseViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: "QRScannerController")
        destViewController.modalPresentationStyle = .fullScreen
        if let navController = destViewController as? UINavigationController {
            let topController = navController.topViewController
            if let uiviewcontroller = topController as? QRScannerController {
                if context is QRScannerDelegate {
                    uiviewcontroller.scannerDelegate = context as? QRScannerDelegate
                }
            }
        }
        
        context.present(destViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var imageFocus: CameraFocusFinder!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
   
    
    func backPage(_ data : Any?){
        self.dismiss(animated: true, completion: {()->Void in
            if let result = data as? String {
                self.scannerDelegate?.onScannerComplete(result)
            }
        })
    }
    
    override func onBackButtonPressed(_ sender: UIButton?) {
        backPage(nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil
        setupVideoPreviewLayer()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // NotificationCenter
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.didChangeCaptureInputPortFormatDescription(notification:)), name: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil)
        self.startScanQRcode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove notificationCenter
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil)
    }
    
    func setupVideoPreviewLayer() {
        self.view.layoutIfNeeded()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.cameraView.layer.addSublayer(videoPreviewLayer!)
            
            // layer
            let layerRect = self.cameraView.layer.bounds
            self.videoPreviewLayer?.frame = layerRect
            self.videoPreviewLayer?.position = CGPoint(x: layerRect.midX, y: layerRect.midY)
            // Start video capture.
            if self.captureSession?.isRunning == false {
                self.captureSession?.startRunning()
            }
            //view.bringSubview(toFront: self.imageFocus)
            
        } catch {
            return
        }
    }
    
    func startScanQRcode() {
        if self.captureSession?.isRunning == false {
            self.captureSession?.startRunning()
        }
    }
    
    func stopScanQRcode() {
        if self.captureSession?.isRunning == true {
            self.captureSession?.stopRunning()
        }
    }
    
    @objc func didChangeCaptureInputPortFormatDescription(notification: NSNotification) {
        if let metadataOutput = self.captureSession?.outputs.last as? AVCaptureMetadataOutput,
            let rect = self.videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: self.imageFocus.focusFrame ?? self.imageFocus.frame) {
            metadataOutput.rectOfInterest = rect
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        stopScanQRcode()
    }
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.stopScanQRcode()
        if metadataObjects.count == 1 {
            // Get the metadata object.
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if let value = metadataObj.stringValue, metadataObj.type == AVMetadataObject.ObjectType.qr {
                backPage(value)
            }
        } else {
            self.startScanQRcode()
        }
        
    }
    
}

protocol QRScannerDelegate {
    func onScannerComplete(_ result : String) -> Bool
}
