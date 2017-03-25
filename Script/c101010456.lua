function c101010456.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010456+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCost(c101010456.cost)
	e1:SetOperation(c101010456.operation)
	c:RegisterEffect(e1)
end
function c101010456.cfilter(c)
	local g=Duel.GetDecktopGroup(tp,c:GetLevel())
	return c:IsSetCard(0x785a) and c:IsLevelAbove(1) and g:FilterCount(Card.IsAbleToRemove,nil)==g:GetCount()
end
function c101010456.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101010456.cfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101010456.cfilter,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Release(g,REASON_COST)
end
function c101010456.operation(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetDecktopGroup(tp,e:GetLabel())
	if rg:GetCount()>rg:FilterCount(Card.IsAbleToRemove,nil) then return end
	Duel.ConfirmDecktop(tp,e:GetLabel())
	local g=Duel.GetDecktopGroup(tp,e:GetLabel())
	local sg=g:Filter(Card.IsSetCard,nil,0x785e)
	if sg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
	end
	Duel.SortDecktop(tp,tp,e:GetLabel()-sg:GetCount())
	for i=1,e:GetLabel()-sg:GetCount() do
		local mg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(mg:GetFirst(),1)
	end
end
