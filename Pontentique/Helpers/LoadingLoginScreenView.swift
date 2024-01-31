import SwiftUI

struct LoadingLoginScreenView: View {
    var body: some View {
        AnimatingDotsView()
    }
}

struct AnimatingDotsView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        // Create a container view for the logo
        let logoContainer = UIView()
        let logoImageView = UIImageView(image: UIImage(named: "AppIcon"))
        logoImageView.layer.cornerRadius = 30
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.borderColor = UIColor.white.cgColor
        logoImageView.clipsToBounds = true
        
        logoContainer.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 125),
            logoImageView.heightAnchor.constraint(equalToConstant: 125),
            logoImageView.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor)
        ])
        
        stackView.addArrangedSubview(logoContainer)
        
        let dots = UIImageView()
        
        stackView.addArrangedSubview(dots)
        showAnimatingDotsInImageView(dots: dots)
        
        // Create a pulse animation
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        
        // Add the pulse animation to the logo image view
        logoImageView.layer.add(pulseAnimation, forKey: "pulse")
        
        return stackView
    }
    
    
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func showAnimatingDotsInImageView(dots: UIImageView) {
        let barWidth: CGFloat = 1
        let spacing: CGFloat = 15
        let numberOfBars: Int = 3
        
        let totalWidth = CGFloat(numberOfBars) * barWidth + CGFloat(numberOfBars - 1) * spacing
        let newX = (dots.bounds.width - totalWidth) / 2
        
        let lay = CAReplicatorLayer()
        lay.frame = CGRect(x: newX, y: 0, width: dots.bounds.width, height: dots.bounds.height)
        let bar = CALayer()
        bar.frame = CGRect(x: 0, y: (dots.bounds.height/2) - 50, width: 8, height: 8)
        bar.cornerRadius = bar.frame.width / 2
        bar.backgroundColor = UIColor.white.cgColor
        lay.addSublayer(bar)
        lay.instanceCount = 3
        lay.instanceTransform = CATransform3DMakeTranslation(15, 0, 0)
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 1
        anim.repeatCount = .infinity
        bar.add(anim, forKey: nil)
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
        
        dots.layer.addSublayer(lay)
    }
}

struct LoadingLoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingLoginScreenView()
    }
}
