import 'dart:math';

/// 儒略日类 - 用于日期和儒略日之间的转换
class JulianDay {
  final double _day;

  const JulianDay(this._day);

  double getDay() => _day;

  /// 根据儒略日创建儒略日对象
  static JulianDay fromJulianDay(double day) {
    return JulianDay(day);
  }

  /// 获取对应的公历时间
  SolarTime getSolarTime() {
    double jd = _day + 0.5;
    int z = jd.floor();
    double f = jd - z;

    late int year, month, day;
    late int hour, minute;
    late double second;

    if (z < 2299161) {
      int a = z;
      int b = a + 1524;
      int c = ((b - 122.1) / 365.25).floor();
      int d = (365.25 * c).floor();
      int e = ((b - d) / 30.6001).floor();

      day = (b - d - (30.6001 * e).floor() + f).floor();

      if (e < 14) {
        month = e - 1;
      } else {
        month = e - 13;
      }

      if (month > 2) {
        year = c - 4716;
      } else {
        year = c - 4715;
      }
    } else {
      int a = ((z - 1867216.25) / 36524.25).floor();
      int b = z + 1 + a - (a / 4).floor();
      int c = b + 1524;
      int d = ((c - 122.1) / 365.25).floor();
      int e = (365.25 * d).floor();
      int g = ((c - e) / 30.6001).floor();

      day = (c - e - (30.6001 * g).floor() + f).floor();

      if (g < 14) {
        month = g - 1;
      } else {
        month = g - 13;
      }

      if (month > 2) {
        year = d - 4716;
      } else {
        year = d - 4715;
      }
    }

    // 计算时分秒
    double totalSeconds = f * 86400.0; // 一天有86400秒
    hour = (totalSeconds / 3600).floor();
    minute = ((totalSeconds - hour * 3600) / 60).floor();
    second = totalSeconds - hour * 3600 - minute * 60;

    return SolarTime(year, month, day, hour, minute, second);
  }
}

/// 公历时间类
class SolarTime {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final double second;

  const SolarTime(
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  );

  /// 获取儒略日
  JulianDay getJulianDay() {
    int y = year;
    int m = month;

    if (m <= 2) {
      m += 12;
      y -= 1;
    }

    int b = 0;
    if (y * 10000 + m * 100 + day >= 15821015) {
      int a = (y / 100).floor();
      b = 2 - a + (a / 4).floor();
    }

    double jd =
        (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        b -
        1524.5;

    // 加上时分秒的部分
    jd += hour / 24.0 + minute / 1440.0 + second / 86400.0;

    return JulianDay(jd);
  }

  @override
  String toString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} '
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toStringAsFixed(2)}';
  }
}

/// 太阳时计算工具类
class SolarTimeUtil {
  /// 标准时间发出地经度(角度表示,东经为正西经为负),北京时间的经度为+120度0分
  final double _j = 120.0;

  /// 默认纬度(角度表示,北纬为正南纬为负),这里是中国标准时间发出地(陕西省渭南市蒲城县)
  // final double _w = 35.0;

  /// 统一东经为正
  final double lng;

  /// 北纬为正,南纬为负
  final double lat;

  /// 构造函数
  SolarTimeUtil({double longitude = 120.0, double latitude = 35.0})
    : lng = longitude,
      lat = latitude {
    if (lng < -180.0 || lng > 180.0) {
      throw Exception('illegal longitude: $lng');
    }
    if (lat < -90.0 || lat > 90.0) {
      throw Exception('illegal latitude: $lat');
    }
  }

  /// 创建太阳时工具实例
  /// @param lng 经度 -180~180
  /// @param lat 纬度 -90~90
  static SolarTimeUtil initLocation({
    double longitude = 120.0,
    double latitude = 35.0,
  }) {
    return SolarTimeUtil(longitude: longitude, latitude: latitude);
  }

  /// 计算平太阳时
  /// @param solartime 公历时间
  /// @returns 平太阳时的公历时间 SolarTime
  SolarTime getMeanSolarTime(SolarTime solartime) {
    double spcjd =
        solartime
            .getJulianDay()
            .getDay(); // 将公历时间转换为儒略日 special jd,这里依然是标准时间,即this._j处的平太阳时
    double deltPty = spcjd - (_j - lng) * 4 / 60 / 24; // 计算地方平太阳时,每经度时差4分钟
    SolarTime pty = JulianDay.fromJulianDay(deltPty).getSolarTime();
    return pty;
  }

  /// 计算真太阳时
  /// @param solartime 公历时间
  /// @returns 真太阳时的公历时间 SolarTime
  SolarTime getRealSolarTime(SolarTime solartime) {
    double spcjd =
        solartime
            .getJulianDay()
            .getDay(); // 将公历时间转换为儒略日 special jd,这里依然是标准时间,即this._j处的平太阳时
    double realZty = _zty(spcjd);
    SolarTime zty = JulianDay.fromJulianDay(realZty).getSolarTime();
    return zty;
  }

  /// 真太阳时模块,sn代表sin
  double _sn(double x) {
    return sin(x * 1.74532925199433E-02);
  }

  /// 真太阳时模块,cn代表cosine
  double _cn(double x) {
    return cos(x * 1.74532925199433E-02);
  }

  /// 真太阳时模块,返回小数部分(负数特殊) returns fractional part of a number
  double _fpart(double x) {
    x = x - x.floor();
    if (x < 0) {
      x = x + 1;
    }
    return x; // 只取小数部份
  }

  /// 真太阳时模块,只取整数部份
  double _ipart(double x) {
    if (x == 0) {
      return 0;
    }
    return (x / x.abs()) * x.abs().floor();
  }

  /// 真太阳时模块
  /// finds a parabola through three points and
  /// returns values of coordinates of extreme value (xe, ye) and
  /// zeros if any (z1, z2)
  /// assumes that the x values are -1, 0, +1
  List<double> _quad(double ym, double y0, double yp) {
    int nz = 0;
    double a = 0.5 * (ym + yp) - y0;
    double b = 0.5 * (yp - ym);
    double c = y0;
    double xe = -b / (2 * a); // x coord of symmetry line
    double ye = (a * xe + b) * xe + c; // extreme value for y in interval
    double dis = b * b - 4 * a * c; // discriminant
    double z1 = 0.0;
    double z2 = 0.0;
    if (dis > 0) {
      // there are zeros
      double dx = 0.5 * sqrt(dis) / a.abs();
      z1 = xe - dx;
      z2 = xe + dx;
      if (z1.abs() <= 1) {
        nz = nz + 1;
      } // This zero is in interval
      if (z2.abs() <= 1) {
        nz = nz + 1;
      } // This zero is in interval
      if (z1 < -1) {
        z1 = z2;
      }
    }
    return [xe, ye, z1, z2, nz.toDouble()];
  }

  /// 真太阳时模块
  /// returns sine of the altitude of either the sun or the moon given the modified julian day of the UT
  /// @param jd 公历時间的儒略日
  /// @param lx 1月亮 2太阳日升日落 3太阳海上微光
  double _sinalt(double jd, int lx) {
    double instant = jd - 2400001.0;
    double t = (instant - 51544.5) / 36525; // 减51544.5为相对2000年01月01日零点
    late double ra, dec;
    if (lx == 1) {
      List<double> moon = _moon(t);
      ra = moon[0];
      dec = moon[1];
    } else {
      List<double> sun = _sun(t);
      ra = sun[0];
      dec = sun[1];
    }

    double mjd0 = _ipart(
      instant,
    ); // UT时间0点;returns the local sidereal time(计算观测地区的恒星时)开始
    double ut = (instant - mjd0) * 24;
    double t2 = (mjd0 - 51544.5) / 36525;
    double gmst = 6.697374558 + 1.0027379093 * ut;
    gmst =
        gmst + (8640184.812866 + (0.093104 - 0.0000062 * t2) * t2) * t2 / 3600;
    double lmst = 24 * _fpart((gmst + lng / 15) / 24); // 结束

    double tau = 15 * (lmst - ra); // hour angle of object
    return _sn(lat) * _sn(dec) + _cn(lat) * _cn(dec) * _cn(tau);
  }

  /// 真太阳时模块,关于太阳的
  /// Returns RA and DEC of Sun to roughly 1 arcmin for few hundred years either side of J2000.0
  List<double> _sun(double t) {
    double p2 = 2 * pi;
    double coseps = 0.91748;
    double sineps = 0.39778;
    double m = p2 * _fpart(0.993133 + 99.997361 * t); // Mean anomaly
    double dl = 6893 * sin(m) + 72 * sin(2 * m); // Eq centre
    double l = p2 * _fpart(0.7859453 + m / p2 + (6191.2 * t + dl) / 1296000);
    // convert to RA and DEC - ecliptic latitude of Sun taken as zero
    double sl = sin(l);
    double x = cos(l);
    double y = coseps * sl;
    double z = sineps * sl;
    double rho = sqrt(1 - z * z);
    double dec = (360 / p2) * atan(z / rho);
    double ra = (48 / p2) * atan(y / (x + rho));
    if (ra < 0) {
      ra = ra + 24;
    }
    return [ra, dec];
  }

  /// 真太阳时模块,关于月球的,Returns RA and DEC of Moon to 5 arc min (ra) and 1 arc min (dec) for a few centuries either side of J2000.0
  /// Predicts rise and set times to within minutes for about 500 years in past - TDT and UT time diference may become significant for long times
  List<double> _moon(double t) {
    double p2 = 2 * pi;
    double arc = 206264.8062;
    double coseps = 0.91748;
    double sineps = 0.39778;
    double l0 = _fpart(0.606433 + 1336.855225 * t); // mean long Moon in revs
    double l = p2 * _fpart(0.374897 + 1325.55241 * t); // mean anomaly of Moon
    double ls = p2 * _fpart(0.993133 + 99.997361 * t); // mean anomaly of Sun
    double d =
        p2 * _fpart(0.827361 + 1236.853086 * t); // diff longitude sun and moon
    double f = p2 * _fpart(0.259086 + 1342.227825 * t); // mean arg latitude
    // longitude correction terms
    double dl = 22640 * sin(l) - 4586 * sin(l - 2 * d);
    dl = dl + 2370 * sin(2 * d) + 769 * sin(2 * l);
    dl = dl - 668 * sin(ls) - 412 * sin(2 * f);
    dl = dl - 212 * sin(2 * l - 2 * d) - 206 * sin(l + ls - 2 * d);
    dl = dl + 192 * sin(l + 2 * d) - 165 * sin(ls - 2 * d);
    dl = dl - 125 * sin(d) - 110 * sin(l + ls);
    dl = dl + 148 * sin(l - ls) - 55 * sin(2 * f - 2 * d);
    // latitude arguments
    double s = f + (dl + 412 * sin(2 * f) + 541 * sin(ls)) / arc;
    double h = f - 2 * d;
    // latitude correction terms
    double n =
        -526 * sin(h) + 44 * sin(l + h) - 31 * sin(h - l) - 23 * sin(ls + h);
    n = n + 11 * sin(h - ls) - 25 * sin(f - 2 * l) + 21 * sin(f - l);
    double lmoon = p2 * _fpart(l0 + dl / 1296000); // Lat in rads
    double bmoon = (18520 * sin(s) + n) / arc; // long in rads
    // convert to equatorial coords using a fixed ecliptic
    double cb = cos(bmoon);
    double x = cb * cos(lmoon);
    double v = cb * sin(lmoon);
    double c = sin(bmoon);
    double y = coseps * v - sineps * c;
    double z = sineps * v + coseps * c;
    double rho = sqrt(1 - z * z);
    double dec = (360 / p2) * atan(z / rho); // 算出月球的视赤纬(apparent declination)
    double ra =
        (48 / p2) * atan(y / (x + rho)); // 算出月球的视赤经(apparent right ascension)
    if (ra < 0) {
      ra = ra + 24;
    }
    return [ra, dec];
  }

  /// 真太阳时模块,rise and set(升降计算) [升起时刻(真太阳时),落下时刻(真太阳时),真平太阳时差(仅类型2),升起时刻(标准时间,仅类型2),落下时刻(标准时间,仅类型2)]
  /// @param jd 公历時间的儒略日值
  /// @param lx 类型:1月亮;2太阳日升日落;3太阳海上微光
  List<dynamic> _risenset(double jd, int lx) {
    double noon = jd.round() - _j / 360.0; // 儒略日,中午12点,減去8小時時差

    List<double> sinho = List.filled(4, 0);
    sinho[1] = _sn(8 / 60); // moonrise - average diameter used(月亮升降)
    sinho[2] = _sn(-50 / 60); // sunrise - classic value for refraction(太阳升降)
    sinho[3] = _sn(-12); // nautical twilight(海上微光)

    int rise = 0; // 是否有升起动作
    dynamic utrise = false; // 升起的时间

    int sett = 0; // 是否有落下动作
    dynamic utset = false; // 落下的时间

    int hour = 1;
    double ym =
        _sinalt(noon + (hour - 1) / 24, lx) -
        sinho[lx]; // See STEP 1 and 2 of Web page description.
    int zero2 =
        0; // 两小时内是否进行了升起和落下两个动作(极地附近有这种情况,如1999年12月25日,经度0,纬度67.43,当天的太阳只有8分钟-_-)
    int above =
        ym > 0 ? 1 : 0; // used later to classify non-risings 是否在地平线上方,用于判断极昼极夜

    do {
      // STEP 1 and STEP 3 of Web page description
      double y0 = _sinalt(noon + (hour + 0) / 24, lx) - sinho[lx];
      double yp = _sinalt(noon + (hour + 1) / 24, lx) - sinho[lx];
      // STEP 4 of web page description
      List<double> quad = _quad(ym, y0, yp);
      double ye = quad[1];
      double z1 = quad[2];
      double z2 = quad[3];
      int nz = quad[4].toInt();

      switch (nz) {
        // cases depend on values of discriminant - inner part of STEP 4
        case 0: // nothing  - go to next time slot
          break;
        case 1: // simple rise / set event
          if (ym < 0) {
            // must be a rising event
            utrise = hour + z1;
            rise = 1;
          } else {
            // must be setting
            utset = hour + z1;
            sett = 1;
          }
          break;
        case 2: // rises and sets within interval
          if (ye < 0) {
            // minimum - so set then rise
            utrise = hour + z2;
            utset = hour + z1;
          } else {
            // maximum - so rise then set
            utrise = hour + z1;
            utset = hour + z2;
          }
          rise = 1;
          sett = 1;
          zero2 = 1;
          break;
      }
      ym = yp; // reuse the ordinate in the next interval
      hour = hour + 2;
    } while (!((hour == 25) ||
        (rise * sett ==
            1))); // STEP 5 of Web page description - have we finished for this object?

    if (utset != false) {
      // 注意这里转成了真太阳时
      utset =
          jd.round() - 0.5 + (utset as double) / 24 - (_j - lng) * 4 / 60 / 24;
    }
    if (utrise != false) {
      utrise =
          jd.round() - 0.5 + (utrise as double) / 24 - (_j - lng) * 4 / 60 / 24;
    }

    double dt = 0.0; // 地方平太阳时 减 真太阳时 的差值,即"真平太阳时差换算表",单位为天
    dynamic tset = (lx == 2) ? utset : 0; // 用于返回标准时间,关于月亮的必须先通过太阳升降获取到dt再转标准时间
    dynamic trise = (lx == 2) ? utrise : 0;

    if ((lx == 2) && (rise * sett == 1)) {
      // 太阳相关,非极昼极夜且有升有落
      while (tset < trise) {
        // 太阳先落下再升起,时区与经度不匹配的情况下会出现此种情况,加一天修正
        tset += 1;
      }
      dt =
          (jd.round() - (trise + (tset - trise) / 2))
              .toDouble(); // 单位为天.比较两者的中午12点(上午和下午是对称的)

      tset = tset - dt + (_j - lng) * 4 / 60 / 24; // 真太阳时转标准时间
      trise = trise - dt + (_j - lng) * 4 / 60 / 24;
    }
    return [utrise, utset, dt, trise, tset];
  }

  /// 真太阳时模块,改编自 https://bieyu.com/ (月亮与太阳出没时间)
  /// 原理:用天文方法计算出太阳升起和落下时刻,中间则为当地正午(自创),与12点比较得到时差;与寿星万年历比较,两者相差在20秒内
  /// @param jd 公历時间的儒略日值
  double _zty(double jd) {
    double dt = _risenset(jd, 2)[2] as double;
    return jd - (_j - lng) * 4 / 60 / 24 + dt; // 转地方平太阳时+修正
  }
}
