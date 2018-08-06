part of complex_base;

abstract class ComplexConstant implements Complex {
  num _real;
  num get real=>_real;
  num _imaginary;
  num get imaginary=>_imaginary;
  num _modulus;
  num get modulus => _modulus;
  num _argument;
  num get argument => _argument;
  num __mod2;
  num get _mod2 => __mod2;


  ComplexCartesian __cart;
  ComplexCartesian get _cart=>__cart;
  ComplexPolar __polar;
  ComplexPolar get _polar=>__polar;
  String toString()=>_cart.toString();

  ComplexConstant._intern(this._real, this._imaginary, this._modulus, this._argument):super() {
    this.__cart = new ComplexCartesian(this._real, this._imaginary);
    this.__polar = new ComplexPolar(this._modulus, this._argument);
    this.__mod2 = math.pow(this._modulus,2);
  }

  Complex operator *(Complex other)=>other._timesComplexPolar(_polar);
  Complex operator +(Complex other)=>other._addComplexCartesian(_cart);
  Complex operator -(Complex other)=>-other._subtractComplexCartesian(_cart);
  Complex operator /(Complex other)=>other._divideComplexPolar(_polar).inverse;
  bool operator ==(dynamic other) {
    if (other is! Complex) return false;
    return this.real == other.real && this.imaginary == other.imaginary;
  }

  Complex _addComplexCartesian(ComplexCartesian other)=>other._addComplexCartesian(_cart);
  Complex _divideComplexPolar(ComplexPolar other)=>other._divideComplexPolar(_polar).inverse;
  bool _similarComplexCartesian(ComplexCartesian other)=>other._similarComplexCartesian(_cart);
  bool _similarComplexPolar(ComplexPolar other)=>other._similarComplexPolar(_polar);

  Complex _subtractComplexCartesian(ComplexCartesian other)=>-other._subtractComplexCartesian(_cart);
  Complex _timesComplexCartesian(ComplexCartesian other)=>other._timesComplexCartesian(_cart);
  Complex _timesComplexPolar(ComplexPolar other)=>other._timesComplexPolar(_polar);

  Complex clone()=>this;

  bool similar(Complex other)=>Complex._closeEnough(other.real, this.real) && Complex._closeEnough(other.imaginary, this.imaginary);

  Complex turn(num angle)=>_polar.turn(angle);
}

class ComplexZero extends ComplexConstant {
  static ComplexZero _singleton = new ComplexZero._intern();
  factory ComplexZero()=>_singleton;
  ComplexZero._intern():super._intern(0,0,0,0);

  Complex operator -()=>this;
  Complex operator *(Complex other)=>this;
  Complex operator +(Complex other)=>other;
  Complex operator -(Complex other)=>-other;
  Complex operator /(Complex other)=>other.inverse;
  Complex get conjugate =>this;
  Complex get inverse => throw "division by zero error";
  Complex pow(num factor)=>this;
  Complex stretch(num factor)=>this;
}

class ComplexOne extends ComplexConstant {
  static ComplexOne _singleton = new ComplexOne._intern();

  factory ComplexOne()=>_singleton;
  ComplexOne._intern():super._intern(1, 0, 1, 0);

  Complex operator -()=>new ComplexMinusOne();
  Complex get conjugate => this;
  Complex get inverse => this;
  Complex pow(num factor)=> this;
  Complex stretch(num factor)=> new ComplexReal(factor);

  Complex operator *(Complex other)=>other;

  @override
  Complex operator /(Complex other)=>other.inverse;
}

class ComplexMinusOne extends ComplexConstant {
  static ComplexMinusOne _singleton = new ComplexMinusOne._intern();

  factory ComplexMinusOne()=>_singleton;
  ComplexMinusOne._intern():super._intern(-1, 0, 1, math.pi);

  Complex operator -()=>new ComplexOne();
  Complex get conjugate => this;
  Complex get inverse => this;
  Complex pow(num factor)=>_polar.pow(factor);
  Complex stretch(num factor)=>new ComplexReal(-factor);
  Complex operator *(Complex other)=>other.stretch(-1);

  Complex operator /(Complex other)=> - other.inverse;
}

class ComplexReal extends ComplexConstant {
  ComplexReal(num l):super._intern(l, 0, l, 0);

  Complex operator -()=>new ComplexReal(-real);
  Complex get conjugate => this;
  Complex get inverse => new ComplexReal(1/real);
  Complex pow(num factor)=>new ComplexReal(math.pow(real, factor));
  Complex stretch(num factor)=>new ComplexReal(real*factor);
  Complex operator *(Complex other)=>other.stretch(real);
  Complex operator /(Complex other)=>other.inverse.stretch(real);
}

class ComplexI extends ComplexConstant {
  static ComplexI _singleton = new ComplexI._intern();
  factory ComplexI() => _singleton;
  ComplexI._intern():super._intern(0,1,1, math.pi/2);

  Complex operator -()=>new ComplexMinusI();
  Complex get conjugate => new ComplexMinusI();
  Complex get inverse => new ComplexMinusI();

  Complex pow(num factor)=>_polar.pow(factor);
  Complex stretch(num factor)=>new ComplexImaginary(factor);
  Complex operator *(Complex other)=>other.turn(this.argument);
}

class ComplexMinusI extends ComplexConstant {
  static ComplexMinusI _singleton = new ComplexMinusI._intern();
  factory ComplexMinusI() => _singleton;
  ComplexMinusI._intern():super._intern(0,-1, 1, -Complex._MATHPI_2);

  Complex operator -()=>new ComplexI();
  Complex get conjugate => new ComplexI();
  Complex get inverse => new ComplexI();

  Complex pow(num factor)=>_polar.pow(factor);
  Complex stretch(num factor)=>new ComplexImaginary(-factor);
  Complex operator *(Complex other)=>other.turn(this.argument);

}

class ComplexImaginary extends ComplexConstant {
  ComplexImaginary(num l):super._intern(0,l,l, Complex._MATHPI_2);

  Complex operator -()=>new ComplexImaginary(-modulus);
  Complex get conjugate => new ComplexImaginary(-modulus);
  Complex get inverse => new ComplexImaginary(-1/modulus);
  Complex pow(num factor)=>_polar.pow(factor);
  Complex stretch(num factor)=>new ComplexImaginary(modulus*factor);
}