import '../../model/AdModel.dart';
import '../../model/Exchange.dart';
import '../../model/Rental.dart';
import 'package:flutter/material.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class SearchPage extends StatefulWidget {
  final String search;
  final UserModel currentUser;

  const SearchPage({Key? key, required this.search, required this.currentUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  late List<AdModel> adList;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    adList = [];
    loadMoreData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> loadMoreData() async {
    setState(() {
      _isLoading = true;
    });
    List<AdModel> newAdList = await adViewModel.searchItems(
        widget.currentUser.latitude,
        widget.currentUser.longitude,
        widget.search);
    setState(() {
      _isLoading = false;
      adList.addAll(newAdList);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchTopBar(),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTopBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 10),
            Text(widget.search),
          ],
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: adList.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < adList.length) {
          if(adList[index] is Rental)
             return _buildRentalItem(adList[index] as Rental);
          else
            return _buildExchangeItem(adList[index] as Exchange);
        } else {
          return _buildLoader();
        }
      },
    );
  }
  Widget _buildRentalItem(Rental rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/image/loading_indicator.gif'),
                  height: 100,
                  width: 100,
                  image: NetworkImage(rental.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rental.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "€${rental.dailyCost}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  // Aggiungere qui la logica per gestire il tap sull'icona del cuore
                  // Ad esempio, potresti aggiornare lo stato per indicare che questo elemento è contrassegnato come preferito
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            thickness: 1.0,
          ),
        ),
      ],
    );
  }



  Widget _buildExchangeItem(Exchange exchange) {
    return
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/image/loading_indicator.gif'),
                  height: 100,
                  width: 100,
                  image: NetworkImage(exchange.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exchange.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  // Aggiungere qui la logica per gestire il tap sull'icona del cuore
                  // Ad esempio, potresti aggiornare lo stato per indicare che questo elemento è contrassegnato come preferito
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),

                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}