module UserMock
    
    ACCOUNT = {
        id: "QSKDJLK",
        sn: "2",
        email: "test@domain.com",
        reference: "",
        first_name: "Aremu",
        last_name: "Smog",
        display_name: "null",
        created_at: "",
        updated_at: ""
    }

    ALL_SUBACCOUNTS = [
        {
        id: "QSKDJLK",
        sn: "2",
        email: "test@domain.com",
        reference: "ajlkskl",
        first_name: "Aremu",
        last_name: "Smog",
        display_name: "null",
        created_at: "",
        updated_at: ""
    },
    {
        id: "QS3DJLK",
        sn: "4",
        email: "test@domain.com",
        reference: "sjld",
        first_name: "Aremu",
        last_name: "Smog",
        display_name: "null",
        created_at: "",
        updated_at: ""
    }
    ]

    NEW_USER = {
        "email" => "test@domain.com",
        "first_name" => "Aremu",
        "last_name" => "Smog",
        "phone_number" => "09012345678"
        }

    UPDATE_INFO ={
        first_name: "Daddy"
    }

    UPDATED_ACCOUNT = {
        id: "QSKDJLK",
        sn: "2",
        email: "test@domain.com",
        reference: "",
        first_name: "Daddy",
        last_name: "Smog",
        display_name: "null",
        created_at: "",
        updated_at: ""
    }

end
