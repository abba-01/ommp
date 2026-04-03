# oMMP Character Lexicon
## Complete Field Dictionary for Unified Observer+Observation Strings

---

## STRING FORMAT OVERVIEW

```
20041114T163045ZP326950N1174150W&12192&15&8A7F2DAERB3E891
└────┬────┘└──┬──┘└──┬──┘└──┬──┘└─┬─┘└┬┘└┬┘└─┬─┘└┬┘└┬┘└─┬─┘
  DATE    TIME   LAT    LON   ALT UH UV OA-CRC M M P TUP-CRC
```

---

## PART 1: OBSERVER ANCHOR (OA) FIELDS

### 1. TIMESTAMP (16 characters)
**Format:** `YYYYMMDDTHHMMSSZ`

| Position | Field | Format | Example | Meaning |
|----------|-------|--------|---------|---------|
| 1-4 | Year | YYYY | 2004 | 4-digit year |
| 5-6 | Month | MM | 11 | 01-12 |
| 7-8 | Day | DD | 14 | 01-31 |
| 9 | Separator | T | T | ISO 8601 delimiter |
| 10-11 | Hour | HH | 16 | 00-23 (UTC) |
| 12-13 | Minute | MM | 30 | 00-59 |
| 14-15 | Second | SS | 45 | 00-59 (leap second = 60) |
| 16 | Zone | Z | Z | UTC (Zulu time) |

**Rules:**
- Always UTC (Z), never local time
- Leap seconds represented as second=60
- No milliseconds in base format (use TA field for precision)

---

### 2. LATITUDE (7 characters)
**Format:** `SDDDDDD` (Sign + 6 digits)

| Position | Field | Format | Example | Meaning |
|----------|-------|--------|---------|---------|
| 1 | Sign | P/N | P | P=Positive (North), N=Negative (South) |
| 2-7 | Degrees | DDDDDD | 326950 | Decimal degrees × 10^6 (32.6950°) |

**Decoding:**
- `P326950` = +32.6950° = 32.6950°N
- `N451230` = -45.1230° = 45.1230°S
- Resolution: 1×10⁻⁶ degrees ≈ 0.11 m at equator

**Valid Range:**
- P000000 to P900000 (0° to 90°N)
- N000000 to N900000 (0° to 90°S)

---

### 3. LONGITUDE (8 characters)
**Format:** `HDDDDDDD` (Hemisphere + 7 digits)

| Position | Field | Format | Example | Meaning |
|----------|-------|--------|---------|---------|
| 1 | Hemisphere | E/W | N | N=Negative (West), E=East |
| 2-8 | Degrees | DDDDDDD | 1174150 | Decimal degrees × 10^6 (117.4150°) |

**Decoding:**
- `N1174150` = -117.4150° = 117.4150°W
- `E0451230` = +045.1230° = 45.1230°E
- Resolution: 1×10⁻⁶ degrees ≈ 0.11 m at equator

**Valid Range:**
- E0000000 to E1800000 (0° to 180°E)
- N0000000 to N1800000 (0° to 180°W)

**Special Cases:**
- Prime Meridian: E0000000 or N0000000
- International Date Line: E1800000 or N1800000

---

### 4. ALTITUDE (Variable: 2-6 characters)
**Format:** `&NNNNN` or `NNNNNN` (compressed or full)

| Character | Meaning | Example | Value |
|-----------|---------|---------|-------|
| & | Leading zero compression | &12192 | 12,192 m |
| & | Sentinel for unknown | & | 9999 (unknown) |
| digits | Meters above WGS84 | 012192 | 12,192 m |

**Rules:**
- `&` replaces leading zeros (must leave ≥1 digit)
- Negative altitudes: use minus sign `-&1234` = -1234m
- Sea level: `&0` or `000000`
- Maximum: 999999 m (999 km)
- Unknown/invalid: `&` alone represents 9999

**Examples:**
- `&5` = 5 m
- `&123` = 123 m
- `&12192` = 12,192 m
- `000500` = 500 m (uncompressed)
- `-&234` = -234 m (below sea level)

---

### 5. HORIZONTAL UNCERTAINTY (UH) (2-5 characters)
**Format:** `&NNN` or `NNNN` (1σ in meters)

| Character | Meaning | Example | Value |
|-----------|---------|---------|-------|
| & | Leading zero compression | &15 | 15 m (1σ) |
| & | Unknown uncertainty | & | 9999 (unknown) |
| digits | Meters (1σ) | 0015 | 15 m |

**Rules:**
- Represents 1-sigma (68% confidence) horizontal position error
- `0000` = at or below quantization floor (~1 m)
- `9999` or `&` = unknown
- Typical values: 1-100m (consumer GPS to survey-grade)

**Examples:**
- `&5` = 5m uncertainty
- `&15` = 15m uncertainty
- `0100` = 100m uncertainty (uncompressed)

---

### 6. VERTICAL UNCERTAINTY (UV) (2-4 characters)
**Format:** `&NN` or `NNN` (1σ in meters)

| Character | Meaning | Example | Value |
|-----------|---------|---------|-------|
| & | Leading zero compression | &8 | 8 m (1σ) |
| & | Unknown uncertainty | & | 9999 (unknown) |
| digits | Meters (1σ) | 008 | 8 m |

**Rules:**
- Represents 1-sigma (68% confidence) vertical position error
- Typically 1.5-2× worse than horizontal
- `000` = at or below quantization floor
- `999` or `&` = unknown

---

### 7. TIME ACCURACY (TA) (Optional, 2-5 characters)
**Format:** `&NNN` or `NNNN` (1σ in milliseconds)

| Character | Meaning | Example | Value |
|-----------|---------|---------|-------|
| & | Leading zero compression | &50 | 50 ms (1σ) |
| & | Unknown | & | 9999 (unknown) |
| digits | Milliseconds (1σ) | 0050 | 50 ms |

**Rules:**
- Represents 1-sigma timing uncertainty
- Used for time-critical observations (radar, GPS timing)
- Used as comparison window near leap seconds
- If omitted, assume millisecond precision

---

### 8. OA CHECKSUM (5 characters)
**Format:** `XXXXX` (CRC32C/24 hex)

| Position | Field | Example | Meaning |
|----------|-------|---------|---------|
| 1-5 | CRC32C/24 | A7F2D | Cyclic redundancy check (24-bit truncated) |

**Rules:**
- Computed over all OA fields (timestamp through UV/TA)
- Hex encoding (0-9, A-F)
- Detects corruption in observer anchor
- Must expand `&` and `x` compressions before verification

---

## PART 2: OBSERVATION TUPLE FIELDS

### 9. META CODE (1 character)
**Location Context - WHERE the observation occurred**

| Code | Name | Domain | Altitude Range | Physics Constraints |
|------|------|--------|----------------|---------------------|
| **A** | **Atmosphere** | 0 < h < 120 km | Ground to Karman line | Drag ∝ ρ(h)·v²; weather effects |
| **S** | **Submerged** | z < 0 | Below water surface | Hydrostatic P=ρ·g·|z|; EM damping; sonic |
| **E** | **Terrestrial** | h ≈ 0 | Ground level | Friction μ; gravity g; surface contact |
| **O** | **Orbit** | 120 km < h < GEO | LEO to geosync | v²=GM/r; no drag; Keplerian |
| **D** | **Deep Space** | r > 1 AU | Beyond Earth orbit | Heliocentric; c-limited; relativity |
| **I** | **Interstellar** | r > 10⁴ AU | Beyond solar system | Lorentz; CMB frame; Δt dilation |

**Variables by META:**
- **A:** (x,y,z,t; v; h; ρ_air; g; wind)
- **S:** (x,y,z,t; v; ρ_water; depth; salinity)
- **E:** (x,y,z,t; v; g; μ; terrain)
- **O:** (a,e,i,Ω,ω,ν; epoch)
- **D:** (x,y,z,t; v; GM_sun)
- **I:** (x,y,z,t; v; z_redshift)

---

### 10. MODAL CODE (1 character)
**Motion/Behavior - HOW the object moved**

| Code | Name | Physics Definition | Observable Signature |
|------|------|-------------------|---------------------|
| **S** | **Stationary** | \|Δr/Δt\| < ε | No position change within sensor resolution |
| **L** | **Linear** | r(t) = r₀ + v·t | Constant velocity; straight line; no acceleration |
| **T** | **Transiting** | Δθ/Δt ≠ 0 | Smooth curved path; bounded trajectory |
| **R** | **Responsive** | ∂v/∂t = f(stimulus) | Acceleration correlated with external events |
| **E** | **Erratic** | \|Δa\| > a_max | Instantaneous direction/speed changes; >human/tech limits |
| **M** | **Morphing** | d(trajectory)/dt chaotic | Unpredictable; non-smooth; jittering |

**Acceleration Thresholds:**
- **L:** a ≈ 0 (< 0.1 m/s²)
- **T:** a < 5g sustained
- **R:** a < 10g, stimulus-driven
- **E:** a > 10g or instantaneous
- **M:** Undefined/chaotic

---

### 11. PLATFORM CODE (1 character)
**Geometric Form - WHAT shape was observed**

| Code | Name | Geometry | Volume/Area Formula | Special Cases |
|------|------|----------|-------------------|---------------|
| **S** | **Sphere** | V = (4/3)πr³ | A = 4πr² | Point-like; isotropic |
| **E** | **Ellipse/Ellipsoid** | 2D: x²/a² + y²/b² = 1 | 3D: V = (4/3)πabc | Disc/oval; a≈b→circle |
| **R** | **Rectangle** | V = l·w·h | A = 2(lw+lh+wh) | Box; cylinder; "tic-tac" |
| **C** | **Chevron** | Defined by apex θ | A = (1/2)ab·sin(θ) | V-shape; boomerang |
| **T** | **Triangle** | Planar polygon | A = (1/2)bh | Delta; pyramid base |
| **F** | **Fusiform** | V = (4/3)πab² | Drag-minimized | Teardrop; streamlined |
| **M** | **Morphing** | d(shape)/dt ≠ 0 | Time-variant | Shape-shifting |
| **U** | **Unknown** | Undefined | N/A | Placeholder |

**Ellipsoid Subtypes:**
- **Oblate:** a=b>c (flattened, disc-like)
- **Prolate:** a=b<c (elongated, cigar)
- **Projection:** 3D ellipsoid → 2D ellipse with axes (a',b')

**CRITICAL:** "Circle" and "disc" are NOT platform codes—they are observer projections of ellipses/ellipsoids. Use **E** or **S**.

---

### 12. TUPLE CHECKSUM (6 characters)
**Format:** `XXXXXX` (CRC32C/24 hex)

| Position | Field | Example | Meaning |
|----------|-------|---------|---------|
| 1-6 | CRC32C/24 | B3E891 | Integrity check over META+MODAL+PLATFORM+measurements |

**Rules:**
- Computed over complete observation tuple
- Hex encoding (0-9, A-F)
- Verifies observation data integrity
- Independent of OA checksum

---

## PART 3: SPECIAL CHARACTERS & COMPRESSION

### Transport Compression Characters

| Char | Name | Function | Example | Expanded |
|------|------|----------|---------|----------|
| **&** | **Run-length** | Replaces leading zeros | &123 | 0123 or 00123 (context) |
| **&** | **Sentinel** | Unknown value | & | 9999 |
| **x** | **Pair-repeat** | Replaces "00" internally | 1x34 | 100034 |

**Compression Rules:**
1. Apply **ONLY** to integer fields: alt, x, y, z, uh, uv, ta, r0, d_m31, a6
2. `&` replaces leading zeros, must leave ≥1 digit
3. `x` replaces internal "00" pairs (after & processing)
4. Expansion mandatory before checksum verification
5. `&` alone may represent 9999 in uncertainty fields

**Examples:**
- `000123` → `&123` (leading zeros)
- `120034` → `12x34` (internal 00)
- `000034` → `&34` (leading zeros only)
- `001003` → `&1x3` (both compressions)

---

## PART 4: CHARACTER SET

### Valid Characters (Case-Sensitive)

| Category | Characters | Count | Usage |
|----------|-----------|-------|-------|
| **Digits** | 0123456789 | 10 | Numeric values |
| **Uppercase** | ABCDEFGHIJKLMNOPQRSTUVWXYZ | 26 | Codes, hemispheres, hex |
| **Delimiters** | T Z | 2 | ISO 8601 timestamp |
| **Signs** | P N E W | 4 | Latitude/longitude signs |
| **Compression** | & x | 2 | Transport compression |
| **Sign** | - | 1 | Negative altitude (rare) |

**Total:** 45 characters

**Excluded:**
- Lowercase (to avoid confusion)
- Punctuation except T, Z, -, &
- Spaces (no delimiters)

---

## PART 5: COORDINATE SYSTEMS

### Geographic Coordinates

| System | Datum | Format | Precision |
|--------|-------|--------|-----------|
| **Latitude** | WGS84 | ±DD.DDDDDD° | 1×10⁻⁶ deg ≈ 0.11m |
| **Longitude** | WGS84 | ±DDD.DDDDDD° | 1×10⁻⁶ deg ≈ 0.11m |
| **Altitude** | WGS84 ellipsoid | Meters | 1 m |

### Alternative Representations

| Field | OA Format | ECEF Format | Notes |
|-------|-----------|-------------|-------|
| **Position** | lat,lon,alt | x,y,z | ECEF canonical; lat/lon advisory |
| **Priority** | ECEF | lat/lon | If mismatch > max(UH,UV,0.5m) |
| **Mismatch** | Flag=1 | Prefer ECEF | Documented in extended fields |

---

## PART 6: EXAMPLE DECODING

### Full String:
```
20041114T163045ZP326950N1174150W&12192&15&8A7F2DAERB3E891
```

### Field-by-Field Breakdown:

| Field | Raw | Decoded | Meaning |
|-------|-----|---------|---------|
| **Date** | 20041114 | 2004-11-14 | November 14, 2004 |
| **Time** | T163045Z | 16:30:45 UTC | 4:30:45 PM Zulu |
| **Latitude** | P326950 | +32.695000° | 32.695°N |
| **Longitude** | N1174150 | -117.415000° | 117.415°W |
| **Altitude** | &12192 | 12,192 m | ~40,000 ft |
| **UH** | &15 | 15 m | ±15m horizontal (1σ) |
| **UV** | &8 | 8 m | ±8m vertical (1σ) |
| **OA-CRC** | A7F2D | Valid | Checksum passes |
| **META** | A | Atmosphere | 0-120km domain |
| **MODAL** | E | Erratic | >10g acceleration |
| **PLATFORM** | R | Rectangle | Box/cylinder shape |
| **Tuple-CRC** | B3E891 | Valid | Observation verified |

### Interpreted:
**"On November 14, 2004 at 16:30:45 UTC, an observer at 32.695°N, 117.415°W, altitude 12,192m (±15m horiz, ±8m vert) recorded an atmospheric object with erratic motion and rectangular form."**

---

## PART 7: VALIDATION RULES

### Checksum Verification
1. Expand all `&` and `x` compressions
2. Compute CRC32C over specified field range
3. Truncate to 24 bits
4. Convert to hex (5-6 chars)
5. Compare with stored checksum

### Range Checks
- **Latitude:** -90° to +90°
- **Longitude:** -180° to +180°
- **Altitude:** -1000m to 999,999m (practical)
- **UH/UV:** 0 to 9999m
- **TA:** 0 to 9999ms
- **Time:** Valid ISO 8601 + leap seconds

### Locking Sequence
1. **OA must precede META** (observer before observation)
2. **META must precede MODAL** (location before motion)
3. **MODAL must precede PLATFORM** (motion before form)
4. **All checksums must validate** before record accepted

---

## PART 8: QUICK REFERENCE TABLE

| Field | Chars | Format | Example | Decoded |
|-------|-------|--------|---------|---------|
| Year | 4 | YYYY | 2004 | 2004 |
| Month | 2 | MM | 11 | November |
| Day | 2 | DD | 14 | 14th |
| Hour | 2 | HH | 16 | 4 PM UTC |
| Minute | 2 | MM | 30 | :30 |
| Second | 2 | SS | 45 | :45 |
| Latitude | 7 | PDDDDDD | P326950 | 32.695°N |
| Longitude | 8 | HDDDDDDD | N1174150 | 117.415°W |
| Altitude | 2-6 | &NNNNN | &12192 | 12,192m |
| UH | 2-5 | &NNN | &15 | ±15m |
| UV | 2-4 | &NN | &8 | ±8m |
| OA-CRC | 5 | XXXXX | A7F2D | Checksum |
| META | 1 | A-I | A | Atmosphere |
| MODAL | 1 | S/L/T/R/E/M | E | Erratic |
| PLATFORM | 1 | S/E/R/C/T/F/M/U | R | Rectangle |
| Tuple-CRC | 6 | XXXXXX | B3E891 | Checksum |

**Total Length:** 50-60 characters (depending on compression)

---

## PART 9: BINARY ENCODING (Optional)

For ultra-compact storage, oMMP supports binary encoding:

| Field | Bits | Range | Encoding |
|-------|------|-------|----------|
| Year | 12 | 0-4095 | Unsigned int |
| Month | 4 | 1-12 | Unsigned int |
| Day | 5 | 1-31 | Unsigned int |
| Hour | 5 | 0-23 | Unsigned int |
| Minute | 6 | 0-59 | Unsigned int |
| Second | 6 | 0-60 | Unsigned int (60=leap) |
| Latitude | 24 | ±90° | Signed fixed-point (×10⁶) |
| Longitude | 25 | ±180° | Signed fixed-point (×10⁶) |
| Altitude | 20 | ±524km | Signed int (meters) |
| UH | 14 | 0-16383m | Unsigned int |
| UV | 14 | 0-16383m | Unsigned int |
| TA | 14 | 0-16383ms | Unsigned int |
| META | 3 | 0-7 | Enum (8 codes) |
| MODAL | 3 | 0-7 | Enum (8 codes) |
| PLATFORM | 3 | 0-7 | Enum (8 codes) |
| CRC32 | 32 | Full | Full checksum |

**Total Binary:** ~190 bits ≈ 24 bytes

---

*oMMP Framework Version: 1.0*  
*Lexicon Status: Reference Standard*  
*Node: Mericus-Claude-oMMP*
