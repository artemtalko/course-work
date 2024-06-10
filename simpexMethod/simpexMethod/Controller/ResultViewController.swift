import UIKit


class ResultViewController: UIViewController {
    private var simplexSolution: [SimplexTableau]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.register(SimplexIterationCell.self, forCellReuseIdentifier: "SimplexIterationCell")
        tableView.register(SimplexHeaderView.self, forHeaderFooterViewReuseIdentifier: "SimplexHeaderView")
        return tableView
    }()
    
    init(simplexSolution: [SimplexTableau]) {
        self.simplexSolution = simplexSolution
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.2314, green: 0.1333, blue: 0.3176, alpha: 1.0)
        
        setupTableView()
        
        print(simplexSolution.last!.pivotSearchingString)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return simplexSolution.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimplexIterationCell", for: indexPath) as! SimplexIterationCell
        cell.configure(with: simplexSolution[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400 // Встановіть відповідну висоту для таблиці
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SimplexHeaderView") as! SimplexHeaderView
        
        switch section {
        case 0:
            headerView.titleLabel.text = "Початкова симплекс-таблиця"
        default:
            headerView.titleLabel.text = "Ітерація \(section)"
        }
   
        if section < simplexSolution.last!.pivotSearchingString!.endIndex {
            headerView.pivotLabel.text = simplexSolution.last!.pivotSearchingString![section]
        }
        else {
            headerView.pivotLabel.text = " "
        }
      
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}




class SimplexHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .left
        
        return label
    }()
    
    let pivotLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(pivotLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pivotLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            pivotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            pivotLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pivotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pivotLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
