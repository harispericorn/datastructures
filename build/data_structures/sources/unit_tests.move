
#[test_only]
module data_structures_address::unit_tests{
    use aptos_framework::event;
    use std::signer;
    use aptos_framework::account;
    use std::string::{Self, String};
    use data_structures_address::todolist;

    #[test (admin=@0x123)]
    fun test_flow(admin:&signer) {
        account::create_account_for_test(signer::address_of(admin));
        todolist::create_list(admin);

        todolist::create_task(admin,string::utf8(b"New Task"));
        let task_count= todolist::getEventCount(admin);
        let task_count_from_resource= todolist::getTaskCounter(admin);
        assert!(task_count == 1, 4);
        assert!(task_count_from_resource==1,5);
        let (id,completed,content,addr)= todolist::getTaskRecord(admin);
        assert!(id==1,10);
        assert!(completed==false,11);
        assert!(content== string::utf8(b"New Task"),12);
        assert!(addr== signer::address_of(admin),13);
        // complete task
        todolist::complete_task(admin, 1);

        let (id,completed,content,addr)= todolist::getTaskRecord(admin);
        assert!(id==1,10);
        //everything else same completed flag will become true
        assert!(completed==true,11);
        assert!(content== string::utf8(b"New Task"),12);
        assert!(addr== signer::address_of(admin),13);
       

    }

    #[test (admin=@0x123)]
    #[expected_failure(abort_code=1)]
    fun cannot_update_inintialized_task(admin:&signer){
        account::create_account_for_test(signer::address_of(admin));
        todolist::complete_task(admin, 1);
    }
    
}