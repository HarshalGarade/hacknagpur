
# advisory.py
# Loads complete crop advisory data dynamically from advisor_data.py

from advisor_data import advisor_data


def show_menu(options):
    """Display a numbered menu and return user choice."""
    print("\nChoose an option:")
    for i, option in enumerate(options, start=1):
        print(f"{i}. {option.capitalize()}")
    print("0. Exit")

    return input("\nEnter your choice: ").strip()


def main():
    print("\n🌾 Welcome to Offline Crop Advisory System 🌾")
    

    # Load all available crops dynamically
    crops = list(advisor_data.keys())

    while True:
        print("\n-----------------------------------------")
        print("Select a Crop for Advisory")
        choice = show_menu(crops)

        if choice == "0":
            print("\n🙏 Thank you for using the advisory system!")
            break

        # Validate crop choice
        if not choice.isdigit() or int(choice) not in range(1, len(crops) + 1):
            print("\n❌ Invalid choice. Try again.")
            continue

        selected_crop = crops[int(choice) - 1]
        print(f"\n🌱 You selected: {selected_crop.capitalize()}")

        # Load available advisory types dynamically
        advisory_types = list(advisor_data[selected_crop].keys())

        while True:
            print("\n--- Select Advisory Type ---")
            adv_choice = show_menu(advisory_types)

            if adv_choice == "0":
                break

            if not adv_choice.isdigit() or int(adv_choice) not in range(1, len(advisory_types) + 1):
                print("\n❌ Invalid choice. Try again.")
                continue

            selected_advice = advisory_types[int(adv_choice) - 1]

            print("\n-----------------------------------------")
            print(f"📌 {selected_crop.capitalize()} - {selected_advice.capitalize()} Guide")
            print("-----------------------------------------\n")

            # Print the actual advisory content
            print(advisor_data[selected_crop][selected_advice])


if __name__ == "__main__":
    main()
