class Triangle
  attr_accessor :side1, :side2, :side3

  def initialize(side1, side2, side3)
    @side1, @side2, @side3 = side1, side2, side3
  end

  def equalateral?
    side1 == side2 && side2 == side3
  end

  def isosceles?
    [side1, side2, side3].uniq.length == 2
  end

  #fixed
  def scalene?
    equalateral? || isosceles? ? false : true
  end

  def reciteFacts
    puts "This triangle is equalateral!" if equalateral?
    puts "This triangle is isosceles! Also,that word is hard to type." if isosceles?
    puts "This triangle is scalene and mathematically boring." if scalene?
    angles = calculateAngles(side1, side2, side3)
    puts "The angles of this triangle are #{angles.join(',')}"
    puts "This triangle is also a right triangle!" if angles.include?(90)
    puts ''
  end

  def calculateAngles(a, b, c)
    angle_a = radiansToDegrees(Math.acos((b**2 + c**2 - a**2) / (2.0 * b * c)))
    angle_b = radiansToDegrees(Math.acos((a**2 + c**2 - b**2) / (2.0 * a * c)))
    angle_c = radiansToDegrees(Math.acos((a**2 + b**2 - c**2) / (2.0 * a * b)))

    [angle_a, angle_b, angle_c]
  end

  def radiansToDegrees(rads)
    (rads * 180 / Math::PI).round
  end
end


triangles = [
	[5,5,5],
	[5,12,13],
]
triangles.each { |sides|
  tri = Triangle.new(*sides)
  tri.reciteFacts
}
