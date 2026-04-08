#!/bin/bash
# Cotton Brick Road - Daily Colombian Dart Frog Generator
# Trigger: Daily at 9:00 AM EST

FROG_NUMBER=$(date +%j | sed 's/^0*//')  # Day of year (1-365)
FROG_ID=$(printf "%03d" $FROG_NUMBER)

echo "🐸 Generating Dart Frog #$FROG_ID for Cotton Brick Road"
echo "Date: $(date)"
echo "Series: Colombian Dart Frogs - 2 Color Combinations"

# Define color combinations (authentic Colombian dart frog patterns)
declare -a COLOR_PAIRS=(
    "Blue:Black"
    "Yellow:Blue" 
    "Red:Blue"
    "Green:Black"
    "Orange:Black"
    "Red:Yellow"
    "Blue:Yellow"
    "Black:Green"
    "Yellow:Black"
    "Red:Black"
    "Blue:Green"
    "Orange:Blue"
    "Green:Yellow"
    "Black:Red"
    "Yellow:Green"
)

# Select colors based on day
COLOR_INDEX=$(( (FROG_NUMBER - 1) % ${#COLOR_PAIRS[@]} ))
COLORS=${COLOR_PAIRS[$COLOR_INDEX]}
COLOR1=$(echo $COLORS | cut -d: -f1)
COLOR2=$(echo $COLORS | cut -d: -f2)

# Calculate realism level (1-10)
# Increases as we approach the 100th frog
if [ $FROG_NUMBER -le 10 ]; then
    REALISM=$FROG_NUMBER
elif [ $FROG_NUMBER -le 50 ]; then
    REALISM=$(( 10 ))
else
    REALISM=10
fi

echo ""
echo "=== DART FROG #$FROG_ID ==="
echo "Colors: $COLOR1 + $COLOR2"
echo "Realism Level: $REALISM/10"
echo "AR Ready: YES"
echo "Location: Cotton Brick Road - Between Levels"
echo ""
echo "Challenge: Spot and tap the frog before it hops away!"
echo "Reward: +10 points + phonics level hint"

# Log to series tracker
echo "$FROG_ID | $COLOR1 | $COLOR2 | $REALISM | $(date +%Y-%m-%d)" >> dart-frog-series.log

# Create daily frog entry
mkdir -p frogs/
cat > frogs/frog-$FROG_ID.md << FROG_DOC
# 🐸 Dart Frog #$FROG_ID - "$(echo $COLOR1) $(echo $COLOR2) Striker"

**Colors:** $COLOR1 + $COLOR2  
**Realism Level:** $REALISM/10  
**Release Date:** $(date +%Y-%m-%d)  
**Status:** ACTIVE

## AR Behavior
- Hops between lily pads on Cotton Brick Road
- Makes soft "ribbit" when approached
- 24-hour availability window

## Challenge
Tap before it hops away to collect Frog Token!

## Educational Fact
Colombian poison dart frogs are among the most toxic animals on Earth. 
Indigenous tribes used their poison on blowgun darts for hunting.

---
*Part of the 100-Day Colombian Dart Frog Series*
*Mrs. Cotton's Academy - Cotton Brick Road*
FROG_DOC

echo ""
echo "✅ Frog #$FROG_ID generated and ready for AR deployment"
echo "📁 Saved to: frogs/frog-$FROG_ID.md"
