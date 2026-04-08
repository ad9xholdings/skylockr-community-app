#!/bin/bash
# Cotton Brick Road - 3 Colombian Dart Frogs Per Day
# Trigger: Daily at 9:00 AM EST

# Get current batch number from file or start at 1
if [ -f .frog-batch ]; then
    BATCH_NUM=$(cat .frog-batch)
else
    BATCH_NUM=1
fi

FROG_BATCH_START=$(( (BATCH_NUM - 1) * 3 + 1 ))

echo "🐸🐸🐸 GENERATING 3 DART FROGS FOR COTTON BRICK ROAD 🐸🐸🐸"
echo "Date: $(date)"
echo "Batch: #$BATCH_NUM"
echo "Frogs #$(printf "%03d" $FROG_BATCH_START) - #$(printf "%03d" $((FROG_BATCH_START + 2)))"
echo ""

# Extended color combinations for Colombian dart frogs (25 pairs = ~8 days)
declare -a COLOR_PAIRS=(
    "Azure:Midnight"       # Blue:Black
    "Golden:Sapphire"      # Yellow:Blue
    "Crimson:Azure"        # Red:Blue
    "Emerald:Obsidian"     # Green:Black
    "Sunset:Shadow"        # Orange:Black
    "Scarlet:Gold"         # Red:Yellow
    "Cobalt:Sunshine"      # Blue:Yellow
    "Onyx:Forest"          # Black:Green
    "Canary:Coal"          # Yellow:Black
    "Ruby:Ebony"           # Red:Black
    "Ocean:Moss"           # Blue:Green
    "Amber:Azure"          # Orange:Blue
    "Lime:Charcoal"        # Green:Yellow
    "Maroon:Obsidian"      # Black:Red
    "Citron:Pine"          # Yellow:Green
    "Teal:Ash"             # Teal:Grey
    "Violet:Jet"           # Purple:Black
    "Peach:Navy"           # Peach:DarkBlue
    "Mint:Smoke"           # Mint:Grey
    "Coral:Ink"            # Coral:Black
    "Lemon:Indigo"         # Lemon:DarkBlue
    "Rose:Tar"             # Pink:Black
    "Turquoise:Carbon"     # Turquoise:Black
    "Mango:Midnight"       # Mango:Black
    "Lavender:Raven"       # Lavender:Black
)

# Frog name generators by color theme
declare -a AZURE_NAMES=("Skyhopper" "Deepdiver" "Tidewalker" "Blueflash" "Aquareign")
declare -a GOLDEN_NAMES=("Sunleaper" "Goldenglide" "Dawnjumper" "Brightscale" "Dayhunter")
declare -a CRIMSON_NAMES=("Bloodhopper" "Crimsonleap" "Redstalker" "Firetoes" "Scarletbound")
declare -a EMERALD_NAMES=("Leafjumper" "Mosswalker" "Greenshadow" "Forestbound" "Vineleaper")
declare -a SUNSET_NAMES=("Duskhopper" "Emberglide" "Sundancer" "Twilighttoes" "Flarebound")
declare -a SCARLET_NAMES=("Redruler" "Scarletflash" "Crimsonking" "Rubyjump" "Bloodbound")
declare -a COBALT_NAMES=("Deepseeker" "Bluestrike" "Cobaltjump" "Oceanleap" "Wavebound")
declare -a ONYX_NAMES=("Nightstalker" "Shadowhopper" "Darkleaper" "Blackshadow" "Voidwalker")
declare -a CANARY_NAMES=("Sunsinger" "Brightcaller" "Goldvoice" "Dawnsong" "Lighthop")
declare -a RUBY_NAMES=("Gemheart" "Redruler" "Crimsonking" "Rubyflash" "Scarletcrown")
declare -a OCEAN_NAMES=("Seawalker" "Tidejumper" "Bluewanderer" "Aquahop" "Deepglide")
declare -a AMBER_NAMES=("Honeyhop" "Goldensap" "Amberleap" "Nectardancer" "Sundrop")
declare -a LIME_NAMES=("Sourleap" "Zesthopper" "Citrusjumper" "Limeflash" "Tangbound")
declare -a MAROON_NAMES=("Winehopper" "Darkred" "Maroonshadow" "Velvetleap" "Crimsonveil")
declare -a CITRON_NAMES=("Zestwalker" "Citronglide" "Lemonshadow" "Sourstride" "Yellowmyst")
declare -a TEAL_NAMES=("Tealwanderer" "Aquaflash" "Turquoisehop" "Seaglide" "Tidestep")
declare -a VIOLET_NAMES=("Purplemyst" "Violethop" "Lavenderleap" "Amethystjump" "Royalspring")
declare -a PEACH_NAMES=("Softleaper" "Peachglide" "Gentlehop" "Blushbound" "Pinkdancer")
declare -a MINT_NAMES=("Freshleap" "Mintwalker" "Coolhop" "Icespring" "Pepperglide")
declare -a CORAL_NAMES=("Reefhopper" "Coralbound" "Tidepink" "Seaspring" "Pinkwave")
declare -a LEMON_NAMES=("Zestking" "Lemondrop" "Citricleap" "Sourking" "Yellowflash")
declare -a ROSE_NAMES=("Rosehop" "Petalbound" "Thornleap" "Pinkshadow" "Bloomjumper")
declare -a TURQUOISE_NAMES=("Tropichop" "Lagoonleap" "Caribbean" "Islandjump" "Bluegreen")
declare -a MANGO_NAMES=("Tropicsun" "Mangoleap" "Goldfruit" "Sweethop" "Sunripe")
declare -a LAVENDER_NAMES=("Dreamhop" "Lavenderwisp" "Purplemist" "Softglide" "Quietleap")

# Function to get name for color
color_to_name() {
    local color=$1
    case $color in
        "Azure") echo "${AZURE_NAMES[$RANDOM % 5]}" ;;
        "Golden") echo "${GOLDEN_NAMES[$RANDOM % 5]}" ;;
        "Crimson") echo "${CRIMSON_NAMES[$RANDOM % 5]}" ;;
        "Emerald") echo "${EMERALD_NAMES[$RANDOM % 5]}" ;;
        "Sunset") echo "${SUNSET_NAMES[$RANDOM % 5]}" ;;
        "Scarlet") echo "${SCARLET_NAMES[$RANDOM % 5]}" ;;
        "Cobalt") echo "${COBALT_NAMES[$RANDOM % 5]}" ;;
        "Onyx") echo "${ONYX_NAMES[$RANDOM % 5]}" ;;
        "Canary") echo "${CANARY_NAMES[$RANDOM % 5]}" ;;
        "Ruby") echo "${RUBY_NAMES[$RANDOM % 5]}" ;;
        "Ocean") echo "${OCEAN_NAMES[$RANDOM % 5]}" ;;
        "Amber") echo "${AMBER_NAMES[$RANDOM % 5]}" ;;
        "Lime") echo "${LIME_NAMES[$RANDOM % 5]}" ;;
        "Maroon") echo "${MAROON_NAMES[$RANDOM % 5]}" ;;
        "Citron") echo "${CITRON_NAMES[$RANDOM % 5]}" ;;
        "Teal") echo "${TEAL_NAMES[$RANDOM % 5]}" ;;
        "Violet") echo "${VIOLET_NAMES[$RANDOM % 5]}" ;;
        "Peach") echo "${PEACH_NAMES[$RANDOM % 5]}" ;;
        "Mint") echo "${MINT_NAMES[$RANDOM % 5]}" ;;
        "Coral") echo "${CORAL_NAMES[$RANDOM % 5]}" ;;
        "Lemon") echo "${LEMON_NAMES[$RANDOM % 5]}" ;;
        "Rose") echo "${ROSE_NAMES[$RANDOM % 5]}" ;;
        "Turquoise") echo "${TURQUOISE_NAMES[$RANDOM % 5]}" ;;
        "Mango") echo "${MANGO_NAMES[$RANDOM % 5]}" ;;
        "Lavender") echo "${LAVENDER_NAMES[$RANDOM % 5]}" ;;
        *) echo "Hopper" ;;
    esac
}

# Generate 3 frogs
for i in 0 1 2; do
    FROG_NUM=$((FROG_BATCH_START + i))
    COLOR_INDEX=$(( (FROG_NUM - 1) % ${#COLOR_PAIRS[@]} ))
    
    # Stop if we've exhausted all colors
    if [ $FROG_NUM -gt $(( ${#COLOR_PAIRS[@]} )) ]; then
        echo "✅ All color pairs exhausted! Total frogs: $((FROG_NUM - 1))"
        break
    fi
    
    COLORS=${COLOR_PAIRS[$COLOR_INDEX]}
    COLOR1=$(echo $COLORS | cut -d: -f1)
    COLOR2=$(echo $COLORS | cut -d: -f2)
    
    # Get name based on primary color
    FROG_NAME=$(color_to_name $COLOR1)
    
    # Calculate realism (1-10, increases every 3 frogs)
    REALISM=$(( (FROG_NUM - 1) / 3 + 1 ))
    if [ $REALISM -gt 10 ]; then
        REALISM=10
    fi
    
    FROG_ID=$(printf "%03d" $FROG_NUM)
    
    echo "═══════════════════════════════════════════════════"
    echo "🐸 FROG #$FROG_ID: \"$FROG_NAME\""
    echo "═══════════════════════════════════════════════════"
    echo "  Colors: $COLOR1 + $COLOR2"
    echo "  Realism Level: $REALISM/10"
    echo "  Challenge: Tap before it hops!"
    echo "  Reward: +10 points + phonics hint"
    echo ""
    
    # Create frog entry
    mkdir -p frogs/
    
    cat > frogs/frog-$FROG_ID-$FROG_NAME.md <> EOF
# 🐸 Dart Frog #$FROG_ID - "$FROG_NAME"

**Colors:** $COLOR1 + $COLOR2  
**Realism Level:** $REALISM/10  
**Release Date:** $(date +%Y-%m-%d)  
**Batch:** #$BATCH_NUM, Frog $(($i + 1))/3

## AR Behavior
- Named "$FROG_NAME" - responds when called!
- Hops between lily pads on Cotton Brick Road
- Makes distinctive "ribbit" when approached
- 24-hour availability window

## Challenge
Spot "$FROG_NAME" and tap before it hops away!

## Educational Fact
Colombian poison dart frogs are among Earth's most toxic animals. 
Indigenous tribes used their poison on blowgun darts for hunting.

## Color Meaning
- **$COLOR1**: Primary body color
- **$COLOR2**: Accent stripes/patterns

---
*Part of the Colombian Dart Frog Series*
*Mrs. Cotton's Academy - Cotton Brick Road*
EOF

    # Log to tracker
    echo "$FROG_ID | $FROG_NAME | $COLOR1 | $COLOR2 | $REALISM | $(date +%Y-%m-%d)" >> dart-frog-series.log
    
    echo "✅ Saved: frogs/frog-$FROG_ID-$FROG_NAME.md"
    echo ""
done

# Increment batch number for next run
echo $((BATCH_NUM + 1)) > .frog-batch

echo "═══════════════════════════════════════════════════"
echo "🐸🐸🐸 BATCH #$BATCH_NUM COMPLETE 🐸🐸🐸"
echo "Total Color Pairs: ${#COLOR_PAIRS[@]}"
echo "Frogs per Day: 3"
echo "Series Duration: ~8 days"
echo "Next Batch: #$((BATCH_NUM + 1))"
echo "═══════════════════════════════════════════════════"
