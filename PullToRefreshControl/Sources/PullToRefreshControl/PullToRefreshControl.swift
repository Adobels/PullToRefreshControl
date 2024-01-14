//
//  PullToRefreshControl.swift
//  PullToRefreshControl
//
//  Created by Blazej SLEBODA on 14/01/2024.
//

import UIKit

public class PullToRefreshControl: UIRefreshControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.cancelOrRestartRefreshingIfNeeded()
        }
    }
    public func pullToRefresh() {
        guard let superview = superview as? UITableView else {
            return
        }
        superview.contentOffset = .init(x: superview.contentOffset.x, y: -frame.height)
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
    public func cancelOrRestartRefreshingIfNeeded() {
        cancelIncompletePullToRefreshIfNeeded()
        restartBeginRefreshingIfNeeded()
    }
    private func restartBeginRefreshingIfNeeded() {
        guard
            isRefreshing,
            let superview = superview as? UITableView
        else { return }
        let oldValueContentOffset = superview.contentOffset
        UIView.performWithoutAnimation {
            endRefreshing()
        }
        DispatchQueue.main.async {
            superview.contentOffset = oldValueContentOffset
            self.beginRefreshing()
        }
    }
    private func cancelIncompletePullToRefreshIfNeeded() {
        guard
            !isRefreshing,
            let superview = superview as? UITableView,
            superview.contentOffset != .zero
        else { return }
        UIView.performWithoutAnimation { [weak self] in
            self?.endRefreshing()
        }
    }
}
