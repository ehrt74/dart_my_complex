part of complex_base;

class ComplexPolar extends Complex {
  num _argument;

  num get argument => _argument;
  num _modulus;

  num get modulus => _modulus;

  num __mod2;

  num get _mod2 => __mod2 ??= math.pow(modulus, 2);

  ComplexPolar(num modulus, num argument) : super._intern() {
    if (modulus < 0) {
      argument += math.pi;
      modulus *= -1;
    }
    this._modulus = modulus;
    this._argument = argument % (Complex._MATH2PI);
  }

  factory ComplexPolar.fromComplexCartesian(ComplexCartesian c) {
    return new ComplexPolar(c.modulus, c.argument);
  }

  String toString() => "(r:${this.modulus}, θ:${this.argument})";

  double _imaginary;
  double _real;

  double get imaginary => _imaginary ??= this.modulus * math.sin(this.argument);

  double get real => _real ??= this.modulus * math.cos(this.argument);

  Complex operator -() =>
      new ComplexPolar(this.modulus, this.argument + math.pi);

  Complex operator +(Complex other) =>
      other._addComplexCartesian(new ComplexCartesian.fromComplexPolar(this));

  Complex operator *(Complex other) => other._timesComplexPolar(this);

  Complex operator -(Complex other) => -other
      ._subtractComplexCartesian(new ComplexCartesian.fromComplexPolar(this));

  Complex operator /(Complex other) => other._divideComplexPolar(this).inverse;

  bool operator ==(dynamic other) {
    if (other is! Complex) return false;
    return (other.modulus == 0 && this.modulus == 0) ||
        (this.modulus == other.modulus && this.argument == other.argument);
  }

  bool similar(Complex other) => other._similarComplexPolar(this);

  Complex clone() => new ComplexPolar(this.modulus, this.argument);

  Complex get conjugate => new ComplexPolar(this.modulus, -this.argument);

  Complex get inverse => new ComplexPolar(1 / this.modulus, -this.argument);

  Complex turn(num other) =>
      new ComplexPolar(this.modulus, this.argument + other);

  Complex pow(num factor) =>
      new ComplexPolar(math.pow(this.modulus, factor), this.argument * factor);

  Complex stretch(num factor) =>
      new ComplexPolar(this.modulus * factor, this.argument);

  Complex _addComplexCartesian(ComplexCartesian other) =>
      other._addComplexCartesian(new ComplexCartesian.fromComplexPolar(this));

  Complex _divideComplexPolar(ComplexPolar other) => new ComplexPolar(
      this.modulus / other.modulus, this.argument - other.argument);

  Complex _subtractComplexCartesian(ComplexCartesian other) => -other
      ._subtractComplexCartesian(new ComplexCartesian.fromComplexPolar(this));

  Complex _timesComplexPolar(ComplexPolar other) => new ComplexPolar(
      this.modulus * other.modulus, this.argument + other.argument);

  Complex _timesComplexCartesian(ComplexCartesian other) =>
      _timesComplexPolar(new ComplexPolar.fromComplexCartesian(other));

  bool _similarComplexCartesian(ComplexCartesian other) =>
      other._similarComplexPolar(this);

  bool _similarComplexPolar(ComplexPolar other) =>
      (this == other) ||
      (Complex._closeEnough(this.modulus, other.modulus) &&
          Complex._closeEnough(this.argument, other.argument));
}
