library complex_base;

import 'dart:math' as math;

part 'complex_cartesian.dart';
part 'complex_constants.dart';
part 'complex_polar.dart';

abstract class Complex {
  static final Complex ZERO=new ComplexZero();
  static final Complex ONE = new ComplexOne();
  static final Complex MINUSONE = new ComplexMinusOne();
  static final Complex I = new ComplexI();
  static final Complex MINUSI = new ComplexMinusI();

  factory Complex.cartesian(num real, num imaginary) {
    return new ComplexCartesian(real, imaginary);
  }

  factory Complex.polar(num modulus, num argument) {
    return new ComplexPolar(modulus, argument);
  }


  num get argument;
  num get modulus;
  num get real;
  num get imaginary;

  Complex get conjugate;
  Complex operator -(Complex other);
  Complex operator /(Complex other);
  Complex operator *(Complex other);
  Complex operator +(Complex other);
  Complex operator -();

  ///Tests if numbers are approximately equal. This catches some rounding errors.
  bool similar(Complex other);

  bool operator ==(other);

  Complex clone();
  Complex pow(num factor);
  Complex get inverse;
  Complex turn(num angle);
  Complex stretch(num factor);

  static final double _MATH2PI = 2*math.pi;
  static final double _MATHPI_2 = math.pi/2;

  num get _mod2;
  bool _similarComplexPolar(ComplexPolar other);
  bool _similarComplexCartesian(ComplexCartesian other);
  Complex _timesComplexPolar(ComplexPolar other);
  Complex _timesComplexCartesian(ComplexCartesian other);
  Complex _divideComplexPolar(ComplexPolar other);
  Complex _addComplexCartesian(ComplexCartesian other);
  Complex _subtractComplexCartesian(ComplexCartesian other);

  Complex._intern();

  static bool _closeEnough(num d1, num d2) {
    if (d1==d2) return true;
    //    if (d1/d2 -1 < 0.0000000001) return true;
    if ((d1-d2).abs()<0.0000000001*d1.abs()) return true;
    if ((d1-d2).abs()<0.0000000001*d2.abs()) return true;
    return false;
  }
}