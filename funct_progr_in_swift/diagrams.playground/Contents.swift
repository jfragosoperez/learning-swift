import Cocoa

/*** Functional way to describe diagrams and discuss how to draw them with Core Graphics. ***/

//We want to build up a data structure that describes the diagram instead of executing
//the drawing commands immediately.

/*** barGraph function takes a list of name (the keys) and values (relative heights of the bars).
F.e. value in the dictionary we draw a suitably sized rectangle 
We then horizontally concatenate these rectangles with the hcat funct. 
Finally we put the bars and the text below each other using the --- operator. 
inspired by the Diagrams library for Haskell (Yorgey 2012)
***/


//BASE

extension NSGraphicsContext {
    var cgContext : CGContextRef {
        let opaqueContext = COpaquePointer(self.graphicsPort)
        return Unmanaged<CGContextRef>.fromOpaque(opaqueContext)
            .takeUnretainedValue()
    }
}

func *(l: CGPoint, r: CGRect) -> CGPoint {
    return CGPointMake(r.origin.x + l.x*r.size.width,
        r.origin.y + l.y*r.size.height)
}

func *(l: CGFloat, r: CGPoint) -> CGPoint {
    return CGPointMake(l*r.x, l*r.y)
}
func *(l: CGFloat, r: CGSize) -> CGSize {
    return CGSizeMake(l*r.width, l*r.height)
}

func pointWise(f: (CGFloat, CGFloat) -> CGFloat,
    l: CGSize, r: CGSize) -> CGSize {
        
        return CGSizeMake(f(l.width, r.width), f(l.height, r.height))
}

func pointWise(f: (CGFloat, CGFloat) -> CGFloat,
    l: CGPoint, r:CGPoint) -> CGPoint {
        
        return CGPointMake(f(l.x, r.x), f(l.y, r.y))
}

func /(l: CGSize, r: CGSize) -> CGSize {
    return pointWise(/, l, r)
}
func *(l: CGSize, r: CGSize) -> CGSize {
    return pointWise(*, l, r)
}
func +(l: CGSize, r: CGSize) -> CGSize {
    return pointWise(+, l, r)
}
func -(l: CGSize, r: CGSize) -> CGSize {
    return pointWise(-, l, r)
}

func -(l: CGPoint, r: CGPoint) -> CGPoint {
    return pointWise(-, l, r)
}
func +(l: CGPoint, r: CGPoint) -> CGPoint {
    return pointWise(+, l, r)
}
func *(l: CGPoint, r: CGPoint) -> CGPoint {
    return pointWise(*, l, r)
}


extension CGSize {
    var point : CGPoint {
        return CGPointMake(self.width, self.height)
    }
}

func isHorizontalEdge(edge: CGRectEdge) -> Bool {
    switch edge {
    case .MaxXEdge, .MinXEdge:
        return true
    default:
        return false
    }
}

func splitRect(rect: CGRect, sizeRatio: CGSize,
    edge: CGRectEdge) -> (CGRect, CGRect) {
        
        let ratio = isHorizontalEdge(edge) ? sizeRatio.width
            : sizeRatio.height
        let multiplier = isHorizontalEdge(edge) ? rect.width
            : rect.height
        let distance : CGFloat = multiplier * ratio
        var mySlice : CGRect = CGRectZero
        var myRemainder : CGRect = CGRectZero
        CGRectDivide(rect, &mySlice, &myRemainder, distance, edge)
        return (mySlice, myRemainder)
}

func splitHorizontal(rect: CGRect,
    ratio: CGSize) -> (CGRect, CGRect) {
        
        return splitRect(rect, ratio, CGRectEdge.MinXEdge)
}

func splitVertical(rect: CGRect,
    ratio: CGSize) -> (CGRect, CGRect) {
        
        return splitRect(rect, ratio, CGRectEdge.MinYEdge)
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let origin = CGPointMake(center.x - size.width/2,
            center.y - size.height/2)
        self.init(origin: origin, size: size)
    }
}

func *(m: CGFloat, v: Vector2D) -> Vector2D {
    return Vector2D(x: m * v.x, y: m * v.y)
}

extension Dictionary {
    var keysAndValues: [(Key, Value)] {
        var result: [(Key, Value)] = []
        for item in self {
            result.append(item)
        }
        return result
    }
}

func normalize(input: [CGFloat]) -> [CGFloat] {
    let maxVal = input.reduce(0) { max($0, $1) }
    return input.map { $0 / maxVal }
}



/*** Geometric kinds we can draw ***/
enum Primitive {
    case Ellipse
    case Rectangle
    case Text(String)
}

enum Diagram {
    //called prim because at the time of writing, the compiler gets confused
    //by a case that has the same name as another enum.
    case Prim(CGSize, Primitive)
    //cases for diagrams that are beside each other (horizontally)
    case Beside(Box<Diagram>, Box<Diagram>)
    //cases for diagrams that are below each other
    case Below(Box<Diagram>, Box<Diagram>)
    //to style the diagrams
    case Attributed(Attribute, Box<Diagram>)
    //control the alignment of smaller parts of the diagram
    case Align(Vector2D, Box<Diagram>)
}

class Box<T> {
    let unbox: T
    init(_ value: T) { self.unbox = value }
}

// A 2-D Vector
struct Vector2D {
    let x: CGFloat
    let y: CGFloat
    
    var point : CGPoint { return CGPointMake(x, y) }
    
    var size : CGSize { return CGSizeMake(x, y) }
}

//data type for describing different attributes of diagrams
enum Attribute {
    case FillColor(NSColor)
}

func barGraph(input: [(String, Double)]) -> Diagram {
    let values: [CGFloat] = input.map { CGFloat($0.1) }
    let nValues = normalize(values)
    let bars = hcat(nValues.map { (x: CGFloat) -> Diagram in
        return rect(width: 1, height: 3 * x)
            .fill(NSColor.blackColor()).alignBottom()
        })
    let labels = hcat(input.map { x in
        return text(width: 1, height: 0.3, text: x.0).alignTop()
        })
    return bars --- labels
}

/*** Calculating and drawing ****/

extension Diagram {
    var size: CGSize {
        switch self {
        case .Prim(let size, _):
            return size
        case .Attributed(_, let x):
            return x.unbox.size
        case .Beside(let l, let r):
            let sizeL = l.unbox.size
            let sizeR = r.unbox.size
            return CGSizeMake(sizeL.width + sizeR.width, max(sizeL.height, sizeR.height))
        case .Below(let l, let r):
            let sizeL = l.unbox.size
            let sizeR = r.unbox.sie
            return CGSizeMake(max(sizeL.width, sizeR.width), sizeL.height + sizeR.height)
        case .Align(_, let r):
            return r.unbox.size
        }
    }
}

//the fit function takes an alignment vector, an input size and a rectangle that
//we want to fit the input size into. We scale it up and mantain its aspect ratio.

func fit(alignment: Vector2D, inputSize: CGSize, rect: CGRect) -> CGRect {
    let scaleSize = rect.size / inputSize
    let scale = min(scaleSize.width, scaleSize.height)
    let size = scale * inputSize
    let space = alignment.size * (size - rect.size)
    return CGRect(origin: rect.origin - space.point, size: size)
}

func draw(context: CGContextReg, bounds: CGRect, diagram: Diagram) {
    switch diagram {
    case .Prim(let size, .Ellipse):
        let frame = fit(Vector2D(x: 0.5, y: 0.5), size, bounds)
        CGContextFillEllipseInRect(context, frame)
    case .Prim(let size, .Rectangle):
        let frame = fit(Vector2D(x: 0.5, y:0.5), size, bounds)
        CGContextFillRect(context, frame)
    case .Prim(let size, .Text(let text)):
        let frame = fit(Vector2D(x: 0.5, y: 0.5), size, bounds)
        let font = NSFont.systemFontOfSize(12)
        let attributes = [NSFontAttributeName: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        attributedText.drawInRect(frame)
    case .Attributed(.FillColor(let color), let d):
        CGContextSaveGState(context)
        color.set()
        draw(context, bounds, d.unbox)
        CGContextRestoreGState(context)
    case .Beside(let left, let right):
        let l = left.unbox
        let r = right.unbox
        let (lFrame, rFrame) = splitHorizontal(bounds, l.size / diagram.size)
        draw(context, lFrame, l)
        draw(context, rFrame, r)
    case .Below(let top, let bottom):
        let t = top.unbox
        let b = bottom.unbox
        let (lFrame, rFrame) = splitVertical(bounds, b.size / diagram.size)
        draw(context, lFrame, b)
        draw(context, rFrame, t)
    case .Align(let vec, let d):
        let diagram = d.unbox
        let frame = fit(vec, diagram.size, bounds)
        draw(context, frame, diagram)
    }
}

//creating views and pdfs

class Draw: NSView {
    let diagram: Diagram
    
    init(frame frameRect: NSRect, diagram: Diagram) {
        self.diagram = diagram
        super.init(frame: frameRect)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func drawRect(diretyRect: NSRect) {
        if let context = NSGraphicsContext.currentContext() {
            draw(context.cgContext, self.bounds, diagram)
        }
    }
}

func pdf(diagram: Diagram, width: CGFloat) -> NSData {
    let unitSize = diagram.size
    let height = width * (unitSize.height / unitSize.width)
    let v: Draw = Draw(frame: NSMakeRect(0, 0, width, height), diagram: diagram)
    return v.dataWithPDFInsideRect(v.bounds)
}

//to make the construction of diagrams easier, it's nice to add some extra
//functions (also called combinators). 

func rect(#width: CGFoat, #height: CGFloat) -> Diagram {
    return Diagram.Prim(CGSizeMake(width, height), .Rectangle)
}

func circle(#diameter: CGFloat) -> Diagram {
    return Diagram.Prim(CGSizeMake(diameter, diameter), .Ellipse)
}

func text(#width: CGFloat, #height: CGFLoat, text theText: String) -> Diagram {
    return Diagram.Prim(CGSizeMake(width, height), .Text(theText))
}

func square(#side: CGFloat) -> Diagram {
    return rect(width: side, height: side)
}


//it also is convenient to have operator for combining diagrams hor. and vertically

infix operator ||| { associativity left }
func ||| (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Beside(Box(l), Box(r))
}

infix operator --- { associativity left }
func --- (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Below(Box(l), Box(r))
}

//other methods for filling and aligninment inside a diagram
extension Diagram {
    func fill(color: NSColor) -> Diagram {
        return Diagram.Attributed(Attribute.FillColor(color), Box(self))
    }
    
    func alignTop() -> Diagram {
        return Diagram.Align(Vector2D(x: 0.5, y: 1), Box(self))
    }
    
    func alignBottom() -> Diagram {
        return Diagram.Align(Vector2D(x: 0.5, y:0), Box(self))
    }
}


//way to concatenate horizontally a list of diagrams

let empty: Diagram = rect(width: 0, height: 0)

func hcat(diagrams: [Diagram]) -> Diagram {
    return diagrams.reduce(empty, combine: |||)
}
