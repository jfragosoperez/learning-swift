import UIKit

typealias Filter = CIImage -> CIImage

/**** BLUR 
Gaussian Blur filter
*****/

func blur(radius: Double) -> Filter {
    return {
        image in let parameters = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ]
        
        let filter = CIFilter(
            name: "CIGaussianBlur",
            withInputParameters: parameters
        )
        
        return filter.outputImage
    }
}


/**** Color overlay 
Overlays an image with a solid color of our choice.
*****/

func colorGenerator(color: UIColor) -> Filter {
    return {
        _ in let parameters = [kCIInputColorKey: color]
        let filter = CIFilter(
            name: "CIConstantColorGenerator",
            withInputParameters: parameters
        )
        
        return filter.outputImage
    }
}

//and the composite filter:

func compositeSourceOverlay(overlay: CIImage) -> Filter {
    return {
        image in let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        
        let filter = CIFilter(
            name: "CISourceOverCompositing",
            withInputParameters: parameters
        )
        
        let cropRect = image.extent()
        
        return filter.outputImage.imageByCroppingToRect(cropRect)
    }
}

//finally we combine both filters to create our color overlay filter

func colorOverlay(color: UIColor) -> Filter {
    return {
        image in let overlay = colorGenerator(color)(image)
        return compositeSourceOverlay(overlay)(image)
    }
}


/*** Composition ****/

let url = NSURL(string: "https://fazefive.files.wordpress.com/2015/06/thailand.jpg")
let image = CIImage(contentsOfURL: url)

let blurRadius = 0.5
let overlayColor = UIColor.redColor().colorWithAlphaComponent(0.2)
let blurredImage = blur(blurRadius)(image)
let overlaidImage = colorOverlay(overlayColor)(blurredImage)

//We can write a filter composition function:

func composeFilters(filter1: Filter, filter2: Filter) -> Filter {
    return { img in filter2(filter1(img)) }
}

//and now we apply two filters by calling:

let myFilter1 = composeFilters(blur(blurRadius), colorOverlay(overlayColor))
let result1 = myFilter1(image)


//Or we can define an operator for filter composition:
infix operator >>> { associativity left }

func >>> (filter1: Filter, filter2: Filter) -> Filter {
    return { img in filter2(filter1(img)) }
}

//and call:
let myFilter2 = blur(blurRadius) >>> colorOverlay(overlayColor)
let result2 = myFilter2(image)



