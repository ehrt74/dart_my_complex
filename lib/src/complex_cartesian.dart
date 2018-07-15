part of complex_base;

class ComplexCartesian extends Complex {
  num _real;
  num _imaginary;

  num get real => _real;

  num get imaginary => _imaginary;

  num _modulus;
  num __mod2;

  num get _mod2 => __mod2 ??= math.pow(real, 2) + math.pow(imaginary, 2);

  num _argument;

  String toString() => "$real + ${imaginary}i";

  num get modulus => _modulus ??= math.sqrt(_mod2);

  num get argument => _argument ??= math.atan2(imaginary, real);

  factory ComplexCartesian.fromComplexPolar(ComplexPolar c) =>
      new ComplexCartesian(c.real, c.imaginary);

  ComplexCartesian(this._real, this._imaginary) : super._intern();

  Complex operator *(Complex other) => other._timesComplexCartesian(this);

  bool operator ==(dynamic other) {
    if (other is! Complex) return false;
    return other.real == this.real && other.imaginary == this.imaginary;
  }

  Complex _timesComplexCartesian(ComplexCartesian other) =>
      new ComplexCartesian(
          this.real * other.real - this.imaginary * other.imaginary,
          this.real * other.imaginary + this.imaginary * other.real);

  Complex _timesComplexPolar(ComplexPolar other) =>
      other._timesComplexPolar(new ComplexPolar.fromComplexCartesian(this));

  Complex operator +(Complex other) => other._addComplexCartesian(this);

  Complex _addComplexCartesian(ComplexCartesian other) => new ComplexCartesian(
      this.real + other.real, this.imaginary + other.imaginary);

  Complex operator -() => new ComplexCartesian(-real, -imaginary);

  Complex operator -(Complex other) => -other._subtractComplexCartesian(this);

  Complex _subtractComplexCartesian(ComplexCartesian other) =>
      new ComplexCartesian(
          this.real - other.real, this.imaginary - other.imaginary);

  Complex _divideComplexPolar(ComplexPolar other) => other
      ._divideComplexPolar(new ComplexPolar.fromComplexCartesian(this))
      .inverse;

  Complex operator /(Complex other) => other
      ._divideComplexPolar(new ComplexPolar.fromComplexCartesian(this))
      .inverse;

  Complex clone() => new ComplexCartesian(this.real, this.imaginary);

  Complex get conjugate => new ComplexCartesian(this.real, -this.imaginary);

  Complex get inverse => new ComplexCartesian(real / _mod2, -imaginary / _mod2);

  Complex pow(num factor) =>
      new ComplexPolar.fromComplexCartesian(this).pow(factor);

  Complex stretch(num factor) =>
      new ComplexCartesian(this.real * factor, this.imaginary * factor);

  Complex turn(num angle) =>
      new ComplexPolar.fromComplexCartesian(this).turn(angle);

  bool _similarComplexCartesian(ComplexCartesian other) =>
      (this == other) ||
      Complex._closeEnough(this.real, other.real) &&
          Complex._closeEnough(this.imaginary, other.imaginary);

  bool _similarComplexPolar(ComplexPolar other) =>
      _similarComplexCartesian(new ComplexCartesian.fromComplexPolar(other));

  bool similar(Complex other) => other._similarComplexCartesian(this);
}
