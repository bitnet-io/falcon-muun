//
//  FeedbackViewController.swift
//  falcon
//
//  Created by Manu Herrera on 18/04/2019.
//  Copyright © 2019 muun. All rights reserved.
//

import UIKit
import Lottie

class FeedbackViewController: MUViewController {

    @IBOutlet fileprivate weak var feedbackIImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var buttonView: ButtonView!
    @IBOutlet fileprivate weak var animationView: AnimationView!

    private var feedback: FeedbackModel

    override var screenLoggingName: String {
        return "feedback"
    }

    override func customLoggingParameters() -> [String: Any]? {
        return feedback.loggingParameters
    }

    init(feedback: FeedbackModel) {
        self.feedback = feedback

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        makeViewTestable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUpNavigation()
    }

    fileprivate func setUpNavigation() {
        navigationController!.setNavigationBarHidden(true, animated: true)
    }

    fileprivate func setUpView() {
        setUpLabels()
        setUpButton()
        setUpImageView()
        setUpLottieView()

        animateView()
    }

    fileprivate func setUpButton() {
        buttonView.delegate = self
        buttonView.buttonText = feedback.buttonText
        buttonView.isEnabled = true
    }

    fileprivate func setUpLabels() {
        titleLabel.text = feedback.title
        titleLabel.textColor = Asset.Colors.title.color
        titleLabel.font = Constant.Fonts.system(size: .h2, weight: .medium)
        titleLabel.alpha = 0

        descriptionLabel.style = .description
        descriptionLabel.attributedText = feedback.description
        descriptionLabel.alpha = 0
        descriptionLabel.textAlignment = .center

        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .descriptionTouched))
    }

    fileprivate func setUpImageView() {
        feedbackIImageView.image = feedback.image
        feedbackIImageView.alpha = 0
    }

    fileprivate func setUpLottieView() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.isHidden = true

        if let animationName = feedback.lottieAnimationName {
            animationView.isHidden = false
            animationView.animation = Animation.named(animationName)
            animationView.play()

            feedbackIImageView.isHidden = true
        }
    }

    fileprivate func animateView() {
        feedbackIImageView.animate(direction: .topToBottom, duration: .short) {
            self.titleLabel.animate(direction: .topToBottom, duration: .short) {
                self.descriptionLabel.animate(direction: .topToBottom, duration: .short)
            }
        }

        buttonView.animate(direction: .bottomToTop, duration: .medium, delay: .short3)
    }

    @objc fileprivate func descriptionTouched() {
        if feedback == FeedbackInfo.deleteWallet {
            let nc = UINavigationController(rootViewController: SupportViewController(type: .anonSupport))
            navigationController!.present(nc, animated: true)
        }
    }

}

extension FeedbackViewController: ButtonViewDelegate {

    func button(didPress button: ButtonView) {
        switch feedback.buttonAction {
        case .popToRoot:
            navigationController!.popToRootViewController(animated: true)
        case .popTo(let vc):
            navigationController!.popTo(type: vc)
        case .dismiss:
            navigationController!.dismiss(animated: true)
        case .setViewControllers(let vcs):
            navigationController!.setViewControllers(vcs, animated: true)
        case .resetToGetStarted:
            resetWindowToGetStarted()
        }
    }

}

extension FeedbackViewController: UITestablePage {

    typealias UIElementType = UIElements.Pages.FeedbackPage

    fileprivate func makeViewTestable() {
        makeViewTestable(view, using: .root)
        makeViewTestable(buttonView, using: .finishButton)
    }

}

fileprivate extension Selector {
    static let descriptionTouched = #selector(FeedbackViewController.descriptionTouched)
}