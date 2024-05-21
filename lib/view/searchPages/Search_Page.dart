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
import 'ExchangePage.dart';
import 'RentalPage.dart';

class SearchPage extends StatefulWidget {
  final String search;
  final UserModel currentUser;

  const SearchPage({Key? key, required this.search, required this.currentUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
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
    final colorScheme= Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: _buildSearchTopBar(),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),

      body: Container(
        color: colorScheme.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTopBar() {
    return Column(
      children: [
        TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onEditingComplete: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(
                  search: _searchController.text,
                  currentUser: widget.currentUser,
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
             return _buildRentalItem(adList[index] as Rental, context);
          else
            return _buildExchangeItem(adList[index] as Exchange, context);
        } else {
          return _buildLoader();
        }
      },
    );
  }
  Widget _buildRentalItem(Rental rental, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context as BuildContext,
          MaterialPageRoute(
            builder: (context) => RentalPage(
              rental: rental,
              currentUser: widget.currentUser,
            ),
          ),
        );
      },
      child: Column(
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
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              thickness: 1.0,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildExchangeItem(Exchange exchange, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context as BuildContext,
          MaterialPageRoute(
            builder: (context) => ExchangePage(
              exchange: exchange,
              currentUser: widget.currentUser,
            ),
          ),
        );
      },
      child: Column(
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
      ),
    );
  }

  Widget _buildLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}