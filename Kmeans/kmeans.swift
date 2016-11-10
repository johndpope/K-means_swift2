//
//  main.swift
//  kmeans
//
//  Created by 成沢淳史 on 7/12/16.
//  Copyright © 2016 成沢淳史. All rights reserved.
//

import Foundation

func add(A : [Float], B : [Float]) -> [Float]
{
    assert(A.count == B.count)
    var ret = [Float](count: A.count, repeatedValue: 0.0)
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

    dispatch_apply(A.count, queue, { (i) in 
        ret[i] = A[i] + B[i]       
    })

    return ret
    
}

func sub(A : [Float], B : [Float]) -> [Float]
{
    assert(A.count == B.count)
    var ret = [Float](count: A.count, repeatedValue: 0.0)
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    
    dispatch_apply(A.count, queue, { (i) in 
        ret[i] = A[i] - B[i]       
    })
    
    return ret
    
}


func pow(A : [Float], B : Float) -> [Float]
{

    var ret = [Float](count: A.count, repeatedValue: 0.0)
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    
    dispatch_apply(A.count, queue, { (i) in 
        ret[i] = pow(A[i], B)
    })
    
    return ret
    
}

func div(A : [Float], B : Float) -> [Float]
{

    var ret = [Float](count: A.count, repeatedValue: 0.0)
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    
    dispatch_apply(A.count, queue, { (i) in 
        ret[i] = A[i] / B      
    })
    
    return ret
    
}

func sqrt(A : [Float]) -> [Float]
{
    
    var ret = [Float](count: A.count, repeatedValue: 0.0)
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    
    dispatch_apply(A.count, queue, { (i) in 
        ret[i] = sqrt(A[i])
    })
    
    return ret
    
}

func sum(A : [Float]) -> Float
{
    
    return A.reduce(0, combine: +)
    
}



func euc(A : [Float], B : [Float]) -> Float
{
    
    var ret : Float
    assert(A.count == B.count)
    
    ret = sqrt(sum(pow(sub(A, B: B), B: 2.0))) / Float(A.count)
    
    return ret
    
}


public class Kmeans : NSObject
{
    private var vecter_length : Int
    private var k : Int
    private var iter : Int
    private var samples : Array<[Float]>
    var clusters : Array<[Float]> = Array()  
    var labels : Array<Int> = Array()
    
    
    public init(samples : Array<[Float]>, k : Int, iter : Int) 
    {

        self.samples = samples
        self.vecter_length = samples[0].count
        self.k = k
        self.iter = iter
        assert(samples.count > k)
        super.init()
        
        for _ in 0..<k 
        {
            let sample_id = Int(arc4random()) % samples.count
            clusters.append(samples[sample_id])
        }
        
        for _ in 0..<samples.count {
            let sample_id = Int(arc4random()) % k
            labels.append(sample_id)
            
        }
        
        assert(samples.count == labels.count)

    }
 
    
    public init(samples : Array<[Float]>, seeds : Array<[Float]>, k : Int, iter : Int) 
    {

        self.samples = samples
        self.vecter_length = samples[0].count
        self.k = k
        self.iter = iter
        assert(samples.count > k)
        self.clusters = seeds
        
        super.init()        
        
        assert(self.clusters.count == self.k)
        
        for _ in 0..<samples.count {
            let sample_id = Int(arc4random()) % k
            labels.append(sample_id)
            
        }
        
        assert(samples.count == labels.count)
        
    }
    
    
    private func search(sample : [Float]) -> Int
    {
        var distance = [Float](count: self.k, repeatedValue: 0.0)
        for (i, center) in self.clusters.enumerate() {
            distance[i] = euc(sample, B: center)
        }
        let minval = distance.minElement()
        let minid = distance.indexOf(minval!)
        
        return minid!
        
    }
    
    private func labeling()
    {
        
        for (i, sample) in self.samples.enumerate()
        {
            let nLabel = search(sample)
            self.labels[i] = nLabel
        }
        
    }
    
    private func update()
    {
        var mean_vecters : Array<[Float]> = Array()  
        var mean_count : Array<Float> = [Float](count: self.k, repeatedValue: 0.0)
        
        for _ in 0..<self.k 
        {
            let mVecter : Array<Float> = [Float](count: vecter_length, repeatedValue: 0.0)
            mean_vecters.append(mVecter)
        }
        
        assert(mean_vecters.count == mean_count.count)
        

        for (i, sample) in zip(labels, samples) {
            mean_vecters[i] = add(mean_vecters[i], B: sample)
            mean_count[i] += 1.0
        }
        
        for i in 0..<self.k {
           mean_vecters[i] = div(mean_vecters[i], B: mean_count[i])            
        }
        
        self.clusters = mean_vecters
        
    }
    
    public func kmeans()
    {
        for _ in 0..<self.iter
        {
            self.labeling()
            self.update()
            //debug()
        }

    }
    
    public func debug() {
        for (i, sample) in samples.enumerate() {
            print("\(sample) : \(labels[i])")
        }
        print("")
    }
    
    
}


