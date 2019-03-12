import UIKit

public class TreeNode {
    
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    
    //初始化
    public init(_ val: Int){
        self.val = val
        self.left = nil
        self.right = nil
    }
}

func invertTree(_ root: TreeNode?) -> TreeNode? {
    
    //邊界條件 遞歸結束或輸入為空情況
    guard let root = root else {
        return nil
    }
    
    //遞歸左右子樹
    invertTree(root.left)
    invertTree(root.right)
    //遞歸左右子節點
    exchangeNode(root)
    
    return root
}

func exchangeNode(_ node: TreeNode?)  {
    
    //判斷是否存在node節點
    if node != nil {
        //交換左右子節點
        let tmp = node?.left
        node?.left = node?.right
        node?.right = tmp
    }
}


