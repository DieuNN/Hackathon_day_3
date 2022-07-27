module {
    public type Laptop = {
        name : Text;
        brandName : Text;
        color : Text;
        price : Float;
    };

    public func getLaptopInfo() : Laptop {
        return ({
            name = "Vivobook A412";
            brandName = "ASUS";
            color = "Silver";
            price = 15000000
        });
    };
};