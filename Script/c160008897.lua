--Chef d'œuvre  Of Greed
function c160008897.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,160008897)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c160008897.cost)
	e1:SetTarget(c160008897.target)
	e1:SetOperation(c160008897.activate)
	c:RegisterEffect(e1)
		--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c160008897.thcost)
	e2:SetTarget(c160008897.thtg)
	e2:SetOperation(c160008897.thop)
	c:RegisterEffect(e2)
end
function c160008897.filter(c)
	return c:IsSetCard(0xc50) or c:IsSetCard(0xc52)  and c:IsAbleToDeck()
end
function c160008897.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160008897.filter,tp,LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c160008897.filter,tp,LOCATION_REMOVED,0,4,4,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c160008897.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c160008897.activate(e,tp,eg,ep,ev,re,r,rp)
local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
Duel.Draw(p,d,REASON_EFFECT)

end
function c160008897.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c160008897.thtg(e,tp,eg,ep,ev,re,r,rp,chk)	
		if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c160008897.filter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_NORMAL)
end
function c160008897.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 and g:IsExists(c160008897.filter2,1,nil) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(p,c160008897.filter2,1,1,nil)
		local tc=sg:GetFirst()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsType(TYPE_SYNCHRO) 
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			if tc:IsAbleToHand() then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,tc)
				Duel.ShuffleHand(p)
			else
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end

	else Duel.ShuffleDeck(p) end
end